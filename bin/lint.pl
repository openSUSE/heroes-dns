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

my @files = File::Find::Rule->file()->name( '*.js' )->in( 'zones' );
my $status = 0;

foreach my $file (@files) {
  open(my $fh, '<', $file) or die "$!";

  my $file_status = 0;

  my $found_d_start = 0;
  my $found_d_end = 0;
  my $found_soa = 0;

  # disable zone file specific logic for "library" files
  my $is_zone = substr($file, 0, 7) ne 'zones/_';

  my $act = 0;

  while(<$fh>) {
    chomp;

    if ( $_ =~ /[\s\t]+$/ ) {
      print "Trailing spaces or tabs in $file, line $..\n";
      $file_status = 1;
    }

    next unless $is_zone;

    if ( $act && $found_soa ) {
      if ( $_ !~ /^$/ ) {
        print "Non-conformant formatting in $file, line $. - line after SOA record should be empty.\n";
        $file_status = 1;
      }

      $act = 0;
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

        # accept only n amount of spaces
        if ( length($1) != 4 ) {
          print "Non-conformant indentation in $file, line $.\n";
          $file_status = 1;
        }

        # parse function call followed by spaces plus function parameters plus trailing comma
        if ( $fun =~ /^(\w+)\(/ ) {
          print "Non-conformant function call in $file, line $. - missing space between function name and opening parenthesis.\n";
        }
        elsif ( $fun !~ /^(\w+)(\s+)\(.*\),$/ ) {
          print "Invalid function call in $file, line $.\n";
          $file_status = 1;
        }
        else {
          if ( $1 eq 'SOA' ) {
            $found_soa_inner = 1;
          }

          # accept only gaps with n amount of spaces to keep uniform indentation even with long function names such as DefaultTTL() or OPENPGPKEY()
          if (length($1) + length($2) != 11) {
            print "Non-conformant function spacing in $file, line $.\n";
          }
        }

        # also accept invalid spacing here to avoid misleading warning about missing SOA record
        if ( $found_soa_inner || $fun =~ /SOA\s*\(/ ) {
          # enable additional logic in next line iteration
          $act = 1;
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
    }

    if (!$found_soa) {
      print "Missing SOA record in $file.\n";
    }

    if ($file_status) {
      $status = 1;
      print "\n";
    }
  }
}

exit $status;
