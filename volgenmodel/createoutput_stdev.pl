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


use strict;
use warnings "all";

my ($symmetric_dir, $istdfile, $symxfm, $output_stdev);
$symmetric_dir = $ARGV[0];
$istdfile = $ARGV[1];
$symxfm = $ARGV[2];
$output_stdev = $ARGV[3];

&do_cmd("/opt/neuroimaging/scripts/volsymm -clobber $istdfile $symxfm $output_stdev");

sub do_cmd {
        print STDOUT "@_\n"; #if $opt{'verbose'};
        system(@_);
}
