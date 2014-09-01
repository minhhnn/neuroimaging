#!/usr/bin/perl
#
# generate a nonlinear model
#
# Andrew Janke - a.janke@gmail.com
#
# Copyright Andrew Janke, The Australian National University.
# Permission to use, copy, modify, and distribute this software and its
# documentation for any purpose and without fee is hereby granted,
# provided that the above copyright notice appear in all copies.  The
# author and the University make no representations about the
# suitability of this software for any purpose.  It is provided "as is"
# without express or implied warranty.


$| = 0;

use strict;
use warnings "all";

my ($lin_methods, $isomodel_base, $fitfile, $modxfm);
$lin_methods = $ARGV[0];
$isomodel_base = $ARGV[1];
$fitfile = $ARGV[2];
$modxfm = $ARGV[3];

my ($lin_method);
#$lin_method = split(/\ /, $lin_methods);
$lin_method = $lin_methods;

&do_cmd("$lin_method -clobber $isomodel_base $fitfile $modxfm");

sub do_cmd {
        print STDOUT "@_\n"; #if $opt{'verbose'};
        system(@_);
}

