#!/usr/bin/perl
#
# Scan infinite cell pitches
# Ondrej Chvala, ochvala@utk.edum  

$mywriter='~/git/LWNUSA/inflat/scripts/writeinfdeck.py --pitch ';
$qsub='~/git/LWNUSA/inflat/qsub.sh';

$pmin = 3.7;    # min pitch [cm]
$pmax = 4.3;   # max pitch [cm]
$pstep= 0.02;    # step pitch [cm]

$p = $pmin;
while ($p < $pmax) {
  $pitch = 1e-3*int($p*1e3+0.5);        # FP math ...
  $mydir = sprintf('%05.3f',$pitch);
  print "$mydir: $pitch\n";
  system("mkdir -p $mydir; cd $mydir; $mywriter $pitch");
  system("cd $mydir; qsub $qsub");
#  system("cd $mydir;sss2 -omp 8 lwnusa.inp");
  $p += $pstep;
}



