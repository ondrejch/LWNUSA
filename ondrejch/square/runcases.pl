#!/usr/bin/perl -w

use strict;
use warnings;

my $pmin = 4.0;
my $pmax = 6.0;
my $pstep = 0.25;

for (my $p=$pmin; $p<=$pmax; $p+=$pstep){ 
  my $pitch  = sprintf("%5.3f",$p);
  print("Pitch =  $pitch\n");
  my $dirname = sprintf("p_%s",$pitch);
  mkdir $dirname;
  system("cd $dirname; ../square_gen.pl $pitch; qsub ./lwnusa.sh; cd ..");
}

