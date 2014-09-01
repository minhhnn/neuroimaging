#! /usr/bin/env perl
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

my ($config_file, $cmodel);
$config_file = $ARGV[0];
$cmodel = $ARGV[1];

my(@conf, $buf);
   
# read in @conf
$buf = `cat $config_file`;

# slurp
if(eval($buf)){
	print STDOUT "Read config from $config_file\n";
}
else{
	die "Error reading config from $config_file (fix it!)\n\n";
}

# create an apropriate identity transformation
my ($initxfm);
$initxfm = "ident.xfm";
&do_cmd("/opt/neuroimaging/scripts/gennlxfm -clobber -like $cmodel -step $conf[0]{'step'} $initxfm");

sub do_cmd {
        print STDOUT "@_\n"; #if $opt{'verbose'};
        system(@_);
}
