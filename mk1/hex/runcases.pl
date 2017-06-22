#!/usr/bin/perl -w

use strict;
use warnings;

my $pmin = 3.5;
my $pmax = 5.3;
my $pstep = 0.1;

for (my $p=$pmin; $p<=$pmax; $p+=$pstep){ 
  my $pitch  = sprintf("%5.3f",$p);
  print("Pitch =  $pitch\n");
  my $dirname = sprintf("p_%s",$pitch);
  mkdir $dirname;
  system("cd $dirname; ../hex_gen.pl $pitch; qsub ./lwnusa.sh; cd ..");
}

