#!/usr/bin/perl
# Script to generate JS arrays for our dnscontrol functions containing
# hosts and prefixes from data in our Salt repository.
# Prints the result to stdout.
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

use YAML::XS 'LoadFile';
$YAML::XS::ForbidDuplicateKeys = 1;

my $base_key = 'SALT_REPOSITORY';
my $base = $ENV{$base_key} || '../salt';
( -d "$base/pillar/infra" ) or die "$base_key is not pointing to a directory containing our Salt repository, bailing out.\n";

my $hosts_data = LoadFile($base . '/pillar/infra/hosts.yaml');
my $networks_data = LoadFile($base . '/pillar/infra/networks.yaml');

my %hosts;
my @net6s;

# construct array with IPv6 prefixes
foreach my $site (keys %{ $networks_data }) {
  next if ($site eq 'pseudo');

  foreach my $network (keys %{ $networks_data->{$site} }) {
    push @net6s, $networks_data->{$site}->{$network}->{'net6'};
  }
}

# construct hash with hostname (string) => IPv6 addresses (array)
# TODO: if a host maps to multiple addresses, the primary address should be the first in the array (expected by AAAA_AND_PTR())
foreach my $host (keys %{ $hosts_data }) {
  my @addresses;

  foreach my $interface (keys %{ $hosts_data->{$host}->{'interfaces'} }) {
    my $ip6 = $hosts_data->{$host}->{'interfaces'}->{$interface}->{'ip6'};
    next unless $ip6;

    # TODO https://progress.opensuse.org/issues/175242
    next unless substr($ip6, 0, 4) eq '2a07';

    # janky logic to only consider addresses which are part of our prefixes (i.e. ones we also have reverse DNS control over)
    # this assumes the address starts with something like "2a07:de40:b27e:1203:"
    # better would be to properly parse the addresses and prefixes and check if one is part of the other
    my $do_reverse = 0;
    my $i = 20;
    my $prefix = substr($ip6, 0, $i);

    foreach my $net6 (@net6s) {
      if (substr($net6, 0, $i) eq $prefix) {
        $do_reverse = 1;
        last;
      }
    };

    next unless $do_reverse;

    push @addresses, (split '/', $ip6, 2)[0];
  }

  if (@addresses) {
    $hosts{$host} = \@addresses;
  }
}

# helper subroutine to print a map in JS format
sub print_elements {
  my @elements = @{$_[0]};
  my $quote = $_[1] eq 0 ? "" : "\"";
  print "{\n";
  # our input data should already be sorted, but might as well also ensure sorting here
  print sprintf "    $quote%s$quote,\n" x @elements, sort @elements;
  print "};\n";
}

sub print_hosts {
  print "var HOSTS_OPENSUSE = ";
  my @hosts_arr = map {
    my @h = @{$hosts{$_}};
    my $i = $#h;
    my $last = pop @h;
    # I'm sorry ...
    "\"$_\": ["                                               # initialize a map element with the hostname as the key, and open a array as the value
      .
      ( $i > 0 ? ( sprintf "\"%s\", " x $i, sort @h ) : "" )  # quote and comma join all IP addresses except the last (tenary condition to avoid warning on empty array)
      .
      ( $last ? sprintf "\"%s\"", $last : "" )                # only quote the last IP address, if there is one
      .
    "]"                                                       # close both the array / finish the value
  } keys %hosts;
  print_elements(\@hosts_arr, 0);
}

print <<END_HEADER;
/*
  THIS FILE IS GENERATED, PLEASE DO NOT EDIT IT DIRECTLY
  `bin/generate-from-salt.pl > zones/_infra.js`
*/

END_HEADER

print_hosts;
