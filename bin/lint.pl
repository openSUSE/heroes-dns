#!/usr/bin/perl
# Script to detect convention violations in our JS zone files.
#
# Copyright (C) 2025 Georg Pfuetzenreuter <mail+opensuse@georg-pfuetzenreuter.net>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

use v5.26;  # Leap 15.6
use warnings;

use File::Find::Rule;

my @files = File::Find::Rule->file()->mindepth(1)->maxdepth(1)->name( '*.js' )->in( 'zones' );
my $status = 0;

foreach my $file (@files) {
  open(my $fh, '<', $file) or die "$!";

  my $complained_soa = 0;

  my $file_status = 0;

  my $found_d_start = 0;
  my $found_d_end = 0;
  my $found_soa = 0;
  my $found_txt = 0;
  my $txt_cont = 0;
  my $txt_cont_1 = 0;
  my $txt_cont_2 = 0;

  # disable zone file specific logic for "library" files
  my $is_zone = substr($file, 0, 7) ne 'zones/_';

  while(<$fh>) {
    chomp;

    if ( $_ =~ /[\s\t]+$/ ) {
      print "Trailing spaces or tabs in $file, line $..\n";
      $file_status = 1;
    }

    next unless $is_zone;

    if ( !$complained_soa && $found_soa ) {
      if ( $_ !~ /^$/ ) {
        print "Non-conformant formatting in $file, line $. - line after SOA record should be empty.\n";
        $file_status = 1;
      }

      $complained_soa = 1;
    }

    if ( $_ =~ /^D/ ) {
      $found_d_start = 1;

      # parse line with D("example.com", REG_OPENSUSE,
      # accept up to three domain levels
      if ( $_ !~ /^D\("\w+(?:.\w{2,5}){1,3}", REG_OPENSUSE,$/ ) {
        print "Non-conformant D() syntax in $file, line $..\n";
        $file_status = 1;
      }
    }
    elsif ( $file eq 'zones/infra_opensuse_org.js' && $_ =~ /^\);$/ ) {
      # TODO: parse additional function calls
      $is_zone = 0;
      next;
    }
    elsif ( $file eq 'zones/uyuni-project_org.js' ) {
      # TODO: handle custom SPF/DKIM in zone
      $is_zone = 0;
      next;
    }
    # parse );
    # as we expect D() to be the only top-level function in the file, the function ending can only belong to D()
    elsif ( $_ =~ /^\);$/ ) {
      $found_d_end = 1;
    }
    # parse line starting with spaces
    elsif ( $_ =~ /^\s/ ) {
      # parse line starting with spaces plus other data
      if ( $_ =~ /^(\s+)(.*)/ ) {
        my $fun = $2;
        my $found_soa_inner = 0;
        my $l = length($1);

        # parse function call followed by spaces plus function parameters plus trailing comma
        if ( $fun =~ /^(\w+)\(/ && !$txt_cont ) {
          print "Non-conformant function call in $file, line $. - missing space between function name and opening parenthesis.\n";
          $file_status = 1;
        }
        # is not one of:
        #  - single line function: TXT ("foo", "bar") <options> ),
        #  - start of multi-line function
        elsif ( $fun !~ /^(\w+)(\s+)\((\".*\"|\d+)(,|.*\),)$/ ) {
          # is a continuation and optional ending of a TXT function started in a previous line
          if ( $found_txt && $_ =~ /^\s{18}".*"(?:,\s+(?:[\w\d\(\)]{0,10}\s+)?\),|,|\s+\),)$/ ) {
            $txt_cont = 1; $txt_cont_1 = 1;
          }
          # is a continuation and definite ending of a TXT function started in a previous line
          elsif ( $found_txt && $_ =~ /^\s{96}.*\),$/ ) {
            $txt_cont = 1; $txt_cont_2 = 1;
          }
          # clear markers from previous lines, the current one is not part of a multi-line function
          elsif ( $txt_cont ) {
            $txt_cont = 0; $txt_cont_1 = 0; $txt_cont_2 = 0;
          }

          # is not one of:
          #  - second line of a TXT function started on the previous line: "bar" ... ),
          #  - first line of a TXT function continued on the next line: TXT ("foo",
          #  - ending of a TXT function started on a previous line
          # separate if block instead of inlining into elsif above to preserve $1 (function name) for use inside else
          if ( ! $txt_cont && ! ( $found_txt && $_ =~ /^\s{18}".*",\s+.*\),$/ ) && $fun !~ /^TXT\s{8}\(".*",$/ && ( $txt_cont && $1 !~ /^\s{96}[\w\d\(\)]{0,10}\),$/ ) ) {
            print "Invalid function call in $file, line $.\n";
            $file_status = 1;
          }

          if ( $found_txt && !$txt_cont ) { $found_txt = 0; };
        }
        else {
          my $reset = 0;

          # mark functions requiring additional logic in the following line
          if ( $1 eq 'SOA' ) { $found_soa_inner = 1 }
          elsif ( $1 eq 'TXT' ) { $found_txt = 1 }

          if ( $1 eq 'TXT' ) { # TODO other record types should be allowed to follow a multi-line TXT one too, ( $1 =~ /^[A-Z]+/ ) ?
            if ( $txt_cont ) { $txt_cont = 0; $txt_cont_1 = 0; $txt_cont_2 = 0; };
          }

          # accept only gaps with n amount of spaces to keep uniform indentation even with long function names such as DefaultTTL() or OPENPGPKEY()
          if ( length($1) + length($2) != 11 ) {
            print "Non-conformant function spacing in $file, line $.\n";
            $file_status = 1;
          }
        }

        if ( ( !$txt_cont && $l != 4 ) || ( $found_txt && $txt_cont_1 && $l != 18 ) && ( $found_txt && $txt_cont_2 && $l != 96 ) ) {
          print "Non-conformant indentation in $file, line $. $found_txt $txt_cont $l\n";
          $file_status = 1;
        }

        # also accept invalid spacing here to avoid misleading warning about missing SOA record
        if ( $found_soa_inner || $fun =~ /SOA\s*\(/ ) {
          # enable additional logic in next line iteration
          $found_soa = 1;
        }
      }
    }
    # accept empty lines inside D()
    elsif ( $_ =~ /^$/ && !$found_d_end) {
      next;
    }
    else {
      print "Excess data in $file, line $.\n";
      $file_status = 1;
    }

  }

  if ($is_zone) {
    if (!$found_d_start) {
      print "Missing line starting with D() in $file.\n";
      $file_status = 1;
    }

    if (!$found_d_end) {
      print "Missing line with an exact ending of D() in $file.\n";
      $file_status = 1;
    }

    if ($found_soa) {
      print "Unexpected SOA record in $file, it's part of DEFAULTS.\n";
      $file_status = 1;
    }

    if ($file_status) {
      $status = 1;
      print "\n";
    }
  }
}

exit $status;
