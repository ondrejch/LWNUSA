#!/usr/bin/perl -w

use strict;
use warnings;
use Time::Piece;
my $today = localtime->ymd();

my $mode   = 'kcode';
my $R      = 17;
my $T      = 42;
my $pitchf = 4.5;
if ($#ARGV == 0 ) { $pitchf = 1.0*$ARGV[0]; }
if ($#ARGV == 1 && $ARGV[1] eq 'dose') { 
    $pitchf = 1.0*$ARGV[0]; 
    $mode = 'dose';
}
if ($#ARGV >  1 || ($#ARGV==1 && $ARGV[1]ne'kcode' && $ARGV[1]ne'dose')) {
  print "The script takes either one argument: pitch [cm], or two arguments: pitch [cm] and mode [kcode|dose]. \n";
  die;
}
my $pitch    = sprintf("%5.3f",$pitchf);
my $hpitch   = sprintf("%5.3f",$pitchf/2.0);
my $latbound = sprintf("%6.3f",$pitchf*$R/2.0);
my $fname    = sprintf("R%d-T%din-P%5.3fcm-ondrejch_%s.i",$R,$T,$pitchf,$today);
my $fnameo   = sprintf("R%d-T%din-P%5.3fcm-ondrejch_%s.out",$R,$T,$pitchf,$today);
print "Pitch = $pitch\n";
print "Writing into: $fname\n";

open(FOUT,">:encoding(UTF-8)","lwnusa.sh");
print FOUT "#!/bin/bash
#PBS -V
#PBS -q fill
#PBS -l nodes=1:ppn=8
hostname
module unload mpi
module load intel/12.1.6 
module load openmpi/1.6.5-intel-12.1 
module load MCNP6

RTP=\"runtp--\".`date \"+\%R\%N\"`
cd \$PBS_O_WORKDIR
mcnp6.mpi TASKS 8 i=$fname o=$fnameo runtpe=/tmp/\$RTP
grep -a \"final result\" $fnameo > done.dat
rm /tmp/\$RTP
";
close FOUT;
chmod 0750, "lwnusa.sh";

open(FOUT,">:encoding(UTF-8)",$fname);

print FOUT "$fname
c Cell cards
1 4 -0.998207 -1          imp:n,p=1 u=2     \$ water inside fuel rod
2 6 -2.70 1 -2            imp:n,p=1 u=2     \$ inner aluminum cladding
3 1 -18.90 2 -3           imp:n,p=1 u=2     \$ uranium fuel
4 6 -2.70 3 -4            imp:n,p=1 u=2     \$ outer aluminum cladding
5 4 -0.998207 4 -5        imp:n,p=1 u=2     \$ water outside fuel slug
6 6 -2.70 5 -6            imp:n,p=1 u=2     \$ aluminum tube of fuel rod
7 4 -0.998207 6 -9        imp:n,p=1 u=2     \$ water outside of fuel rod
8 4 -0.998207 -8          imp:n,p=1 fill=1  \$ fill fuel rods into lattice
9 4 -0.998207 -7 lat=1 fill=-8:8 -8:8 0:0   \$ fill lattice into real world
     1 1 1 1 1 1 2 2 2 2 2 1 1 1 1 1 1 
     1 1 1 1 2 2 2 2 2 2 2 2 2 1 1 1 1 
     1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 
     1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 
     1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 
     1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 
     2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 
     2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 
     2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 
     2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 
     2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 
     1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 
     1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 
     1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 
     1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 
     1 1 1 1 2 2 2 2 2 2 2 2 2 1 1 1 1 
     1 1 1 1 1 1 2 2 2 2 2 1 1 1 1 1 1 
     u=1 imp:n,p=1
10 4 -.998207 8 -9 -13    imp:n,p=1         \$ water in tank
11 6 -2.70 9 -10          imp:n,p=1         \$ tank walls
12 10 -2.2994 -11         imp:n,p=1         \$ concrete floor
13 10 -2.2994 -12         imp:n,p=1         \$ concrete ceiling
14 3 -1.18e-03 -99 10 11 12 imp:n,p=1       \$ air in room
15 3 -1.18e-03 -9 13      imp:n,p=1         \$ air in tank
99 0 99                   imp:n,p=0         \$ outside world

c Surface cards
1 RCC 0.0 0.0 0.0 0.0 0.0 126.3 0.58        \$ inner radius of fuel clad
2 RCC 0.0 0.0 0.0 0.0 0.0 126.3 0.707       \$ inner radius of U fuel
3 RCC 0.0 0.0 0.0 0.0 0.0 126.3 1.398       \$ outer radius of U fuel
4 RCC 0.0 0.0 0.0 0.0 0.0 126.3 1.525       \$ outer radius of fuel clad
5 RCC 0.0 0.0 -9.87 0.0 0.0 146.0 1.59      \$ inner radius of fuel rod tube
6 RCC 0.0 0.0 -9.87 0.0 0.0 146.0 1.655     \$ outer radius of fuel rod tube
7 RPP -$hpitch $hpitch -$hpitch $hpitch -9.87 136.13                \$ unit cell dimensions
8 RPP -$latbound $latbound -$latbound $latbound -9.87 136.13            \$ lattice (core) boundary
9 RPP -53.34 53.34 -53.34 53.34 -9.87 171.48          \$ inner surface of tank
10 RPP -53.8 53.8 -53.8 53.8 -11.4 171.48             \$ outer surface of Tank
11 RPP -100.8 100.8 -100.8 100.8 -57.12 -26.64        \$ concrete floor
12 RPP -100.8 100.8 -100.8 100.8 247.68 262.92        \$ concrete ceiling
13 pz  156.24                                         \$ water level in tank
99 RPP -100.8 100.8 -100.8 100.8 -57.12 262.92        \$ outside world 

c Data Cards
print
c
c Materials
c
c natural uranium metal
m1   92234 -0.000057
     92235 -0.007204
     92238 -0.992739
c
c
c ////////// Humid Air ////////// 
c
c  material 3 is humid air. density = 1.18e-03 g/cc
c
m3     1001.70c  -1.2124e-03 
       8016.70c  -2.389e-01 
       7014.70c  -7.4701e-01 
      18036.70c -3.8599E-05
      18038.70c -7.6519E-06
      18040.70c -1.2694E-02
       6000.70c  -1.3848E-04
c
mt3   lwtr
c
c  water   
m4 1001 -0.111894 8016 -0.888106
mt4 lwtr
c
c aluminum (not used) 
m5 13027 -1.000000
c
c aluminum
m6   12000 -0.010000
     13027 -0.972000
     14000 -0.006000
     22000 -0.000880
     24000 -0.001950
     25055 -0.000880
     26000 -0.004090
     29000 -0.002750
     30000 -0.001460
c
c  steel (not used)
m7    6012 -3.95366E-04
     14028 -4.59332E-03
     14029 -2.41681E-04
     14030 -1.64994E-04
     15031 -2.30000E-04
     16032 -1.42073E-04
     16033 -1.15681E-06
     16034 -6.75336E-06
     16036 -1.68255E-08
     24050 -7.93000E-03
     24052 -1.59029E-01
     24053 -1.83798E-02
     24054 -4.66139E-03
     25055 -1.00000E-02
     26054 -3.96166E-02
     26056 -6.44901E-01
     26057 -1.51600E-02
     26058 -2.05287E-03
     28058 -6.21579E-02
     28060 -2.47678E-02
     28061 -1.09461E-03
     28062 -3.54721E-03
     28064 -9.32539E-04
c
c ////////// Concrete ////////// 
c
c material 10 is oak ridge concrete. density = 2.2994 g/cc
c
m10    1001.70c  -0.006187   \$  Hydrogen
C
       6000.70c  -0.1752     \$  Carbon
c 
       8016.70c  -0.4102     \$  Oxygen
C
      11023.70c  -0.000271    \$  Sodium
C
      12024.70c  -0.02542     \$  Magnisium
      12025.70c  -0.00335
      12026.70c  -0.00384
C
      13027.70c  -0.01083     \$  Aluminum
C
      14028.70c  -0.031676    \$  Silicon
      14029.70c  -0.001667
      14030.70c  -0.001138
      19039.70c  -0.0010576   \$  Potassium
      19040.70c  -1.361E-07
      19041.70c  -0.000080
C
      20040.70c  -0.310572    \$  Calcium
      20042.70c  -0.002176
      20043.70c  -0.000465
      20044.70c  -0.007351
      20046.70c  -1.474E-05
      20048.70c  -0.000719
C
      26054.70c -0.00044     \$  Iron
      26056.70c -0.00715
      26057.70c -0.00017
      26058.70c -0.00002
c
mt10  lwtr
c
c ----------- Talies ---------------
c
c Tally 32 - neutron surface flux at external edge of tank and ceiling
F32:n 10.1 10.2 10.3 10.4 10.6 9.5 12.6 
c
c energy structure for neutron tallies (MeV)
E32 0 2.50E-08
       1.00E-07
       1.00E-06
       1.00E-05
       1.00E-04
       1.00E-03
       1.00E-02
       1.00E-01
       5.00E-01
       1.00E+00
       2.50E+00
       5
       7
       10
       14
c
c Tally 42 - photon surface flux at external edge of tank and ceiling
F42:p 10.1 10.2 10.3 10.4 10.6 9.5 12.6
c
c energy structure for photon tallies (MeV)
E42 0 0.01
       0.015
       0.020
       0.030
       0.040
       0.050
       0.060
       0.080
       0.1
       0.15
       0.2
       0.3
       0.4
       0.5
       0.6
       0.8
       1.0
       2.0
       4.0
       6.0
       8.0
       10
c
c Tally 15 - neutron surface flux at point detector above water
F15:p 0.0 0.0 156.34001 0.1
c
c energy structure for neutron tallies (MeV)
E15 0 2.50E-08
       1.00E-07
       1.00E-06
       1.00E-05
       1.00E-04
       1.00E-03
       1.00E-02
       1.00E-01
       5.00E-01
       1.00E+00
       2.50E+00
       5
       7
       10
       14
c
c Tally 25 - photon surface flux at point detector above water
F25:p 0.0 0.0 156.34001 0.1
c
c energy structure for photon tallies (MeV)
E25 0 0.01
       0.015
       0.020
       0.030
       0.040
       0.050
       0.060
       0.080
       0.1
       0.15
       0.2
       0.3
       0.4
       0.5
       0.6
       0.8
       1.0
       2.0
       4.0
       6.0
       8.0
       10
c
c Tally 35 - neutron surface flux at point detector at top of tank
F35:p 0.0 0.0 171.5801 0.1
c
c energy structure for neutron tallies (MeV)
E35 0 2.50E-08
       1.00E-07
       1.00E-06
       1.00E-05
       1.00E-04
       1.00E-03
       1.00E-02
       1.00E-01
       5.00E-01
       1.00E+00
       2.50E+00
       5
       7
       10
       14
c
c Tally 45 - photon surface flux at point detector at top of tank
F45:p 0.0 0.0 171.5801 0.1
c
c energy structure for photon tallies (MeV)
E45 0 0.01
       0.015
       0.020
       0.030
       0.040
       0.050
       0.060
       0.080
       0.1
       0.15
       0.2
       0.3
       0.4
       0.5
       0.6
       0.8
       1.0
       2.0
       4.0
       6.0
       8.0
       10
c
c Tally 55 - neutron surface flux at point detector at ceiling
F55:p 0.0 0.0 247.5799 0.1
c
c energy structure for neutron tallies (MeV)
E55 0 2.50E-08
       1.00E-07
       1.00E-06
       1.00E-05
       1.00E-04
       1.00E-03
       1.00E-02
       1.00E-01
       5.00E-01
       1.00E+00
       2.50E+00
       5
       7
       10
       14
c
c Tally 65 - photon surface flux at point detector at ceiling
F65:p 0.0 0.0 247.5799 0.1
c
c energy structure for photon tallies (MeV)
E65 0 0.01
       0.015
       0.020
       0.030
       0.040
       0.050
       0.060
       0.080
       0.1
       0.15
       0.2
       0.3
       0.4
       0.5
       0.6
       0.8
       1.0
       2.0
       4.0
       6.0
       8.0
       10
c
c Tally 75 - neutron surface flux at point detector at -x side of tank (midpoint of fuel)
F75:p -50.6999 0.0 63.15 0.1
c
c energy structure for neutron tallies (MeV)
E75 0 2.50E-08
       1.00E-07
       1.00E-06
       1.00E-05
       1.00E-04
       1.00E-03
       1.00E-02
       1.00E-01
       5.00E-01
       1.00E+00
       2.50E+00
       5
       7
       10
       14
c
c Tally 85 - photon surface flux at point detector at -x side of tank (midpoint of fuel)
F85:p -50.6999 0.0 63.15 0.1
c
c energy structure for photon tallies (MeV)
E85 0 0.01
       0.015
       0.020
       0.030
       0.040
       0.050
       0.060
       0.080
       0.1
       0.15
       0.2
       0.3
       0.4
       0.5
       0.6
       0.8
       1.0
       2.0
       4.0
       6.0
       8.0
       10
c
c Tally 95 - neutron surface flux at point detector at bottom edge of tank
F95:p -50.7699 0.0 7.62 0.1
c
c energy structure for neutron tallies (MeV)
E95 0 2.50E-08
       1.00E-07
       1.00E-06
       1.00E-05
       1.00E-04
       1.00E-03
       1.00E-02
       1.00E-01
       5.00E-01
       1.00E+00
       2.50E+00
       5
       7
       10
       14
c
c Tally 105 - photon surface flux at point detector at bottom edge of tank
F105:p -50.7699 0.0 7.62 0.1
c
c energy structure for photon tallies (MeV)
E105 0 0.01
       0.015
       0.020
       0.030
       0.040
       0.050
       0.060
       0.080
       0.1
       0.15
       0.2
       0.3
       0.4
       0.5
       0.6
       0.8
       1.0
       2.0
       4.0
       6.0
       8.0
       10
c
c Tally 115 - Point Flux Tally on Outer Wall----------------------
F115:n 48 0 75 .1
c Response Function-----------------------------------------------
DE0 0 2.5E-8 1.0E-7 1.0E-6 1.0E-5 1.0E-4 1.0E-3 1.0E-2 2.0E-2 5.0E-2
        1.0E-1 1.5E-1 2.0E-1 5.0E-1 1.0 1.2 2.0 3.0 4.0 5.0 6.0 7.0
        8.0 10.0 12.0 14.0
DF0 0 0.001188 0.0014868 0.0020268 0.0023184 0.002322
        0.0021744 0.002772 0.003672 0.006228 0.007632 0.012672
        0.015264 0.027 0.04176 0.0468 0.06408 0.0792 0.09 0.09792
        0.10152 0.1044 0.10692 0.11124 0.11592 0.11988
mode n p";

if ($mode eq 'kcode') {
    print FOUT "KCODE 25000 0.84 300 1000
KSRC  -28.95 -28.95 121.3   -28.95 -28.95 101.3   -28.95 -28.95 86.3
      -28.95 -26.05 121.3   -28.95 -26.05 101.3   -28.95 -26.05 86.3
      -28.95 -21.05 121.3   -28.95 -21.05 101.3   -28.95 -21.05 86.3
      -28.95 -11.05 121.3   -28.95 -11.05 101.3   -28.95 -11.05 86.3
      -28.95 -1.05 121.3   -28.95 -1.05 101.3   -28.95 -1.05 86.3
      -28.95 1.05 121.3   -28.95 1.05 101.3   -28.95 1.05 86.3
      -28.95 11.05 121.3   -28.95 11.05 101.3   -28.95 11.05 86.3
      -28.95 21.05 121.3   -28.95 21.05 101.3   -28.95 21.05 86.3
      -28.95 26.05 121.3   -28.95 26.05 101.3   -28.95 26.05 86.3
      -28.95 28.95 121.3   -28.95 28.95 101.3   -28.95 28.95 86.3
      -26.05 -28.95 121.3   -26.05 -28.95 101.3   -26.05 -28.95 86.3
      -26.05 -26.05 121.3   -26.05 -26.05 101.3   -26.05 -26.05 86.3
      -26.05 -21.05 121.3   -26.05 -21.05 101.3   -26.05 -21.05 86.3
      -26.05 -11.05 121.3   -26.05 -11.05 101.3   -26.05 -11.05 86.3
      -26.05 -1.05 121.3   -26.05 -1.05 101.3   -26.05 -1.05 86.3
      -26.05 1.05 121.3   -26.05 1.05 101.3   -26.05 1.05 86.3
      -26.05 11.05 121.3   -26.05 11.05 101.3   -26.05 11.05 86.3
      -26.05 21.05 121.3   -26.05 21.05 101.3   -26.05 21.05 86.3
      -26.05 26.05 121.3   -26.05 26.05 101.3   -26.05 26.05 86.3
      -26.05 28.95 121.3   -26.05 28.95 101.3   -26.05 28.95 86.3
      -21.05 -28.95 121.3   -21.05 -28.95 101.3   -21.05 -28.95 86.3
      -21.05 -26.05 121.3   -21.05 -26.05 101.3   -21.05 -26.05 86.3
      -21.05 -21.05 121.3   -21.05 -21.05 101.3   -21.05 -21.05 86.3
      -21.05 -11.05 121.3   -21.05 -11.05 101.3   -21.05 -11.05 86.3
      -21.05 -1.05 121.3   -21.05 -1.05 101.3   -21.05 -1.05 86.3
      -21.05 1.05 121.3   -21.05 1.05 101.3   -21.05 1.05 86.3
      -21.05 11.05 121.3   -21.05 11.05 101.3   -21.05 11.05 86.3
      -21.05 21.05 121.3   -21.05 21.05 101.3   -21.05 21.05 86.3
      -21.05 26.05 121.3   -21.05 26.05 101.3   -21.05 26.05 86.3
      -21.05 28.95 121.3   -21.05 28.95 101.3   -21.05 28.95 86.3
      -11.05 -28.95 121.3   -11.05 -28.95 101.3   -11.05 -28.95 86.3
      -11.05 -26.05 121.3   -11.05 -26.05 101.3   -11.05 -26.05 86.3
      -11.05 -21.05 121.3   -11.05 -21.05 101.3   -11.05 -21.05 86.3
      -11.05 -11.05 121.3   -11.05 -11.05 101.3   -11.05 -11.05 86.3
      -11.05 -1.05 121.3   -11.05 -1.05 101.3   -11.05 -1.05 86.3
      -11.05 1.05 121.3   -11.05 1.05 101.3   -11.05 1.05 86.3
      -11.05 11.05 121.3   -11.05 11.05 101.3   -11.05 11.05 86.3
      -11.05 21.05 121.3   -11.05 21.05 101.3   -11.05 21.05 86.3
      -11.05 26.05 121.3   -11.05 26.05 101.3   -11.05 26.05 86.3
      -11.05 28.95 121.3   -11.05 28.95 101.3   -11.05 28.95 86.3
      -1.05 -28.95 121.3   -1.05 -28.95 101.3   -1.05 -28.95 86.3
      -1.05 -26.05 121.3   -1.05 -26.05 101.3   -1.05 -26.05 86.3
      -1.05 -21.05 121.3   -1.05 -21.05 101.3   -1.05 -21.05 86.3
      -1.05 -11.05 121.3   -1.05 -11.05 101.3   -1.05 -11.05 86.3
      -1.05 -1.05 121.3   -1.05 -1.05 101.3   -1.05 -1.05 86.3
      -1.05 1.05 121.3   -1.05 1.05 101.3   -1.05 1.05 86.3
      -1.05 11.05 121.3   -1.05 11.05 101.3   -1.05 11.05 86.3
      -1.05 21.05 121.3   -1.05 21.05 101.3   -1.05 21.05 86.3
      -1.05 26.05 121.3   -1.05 26.05 101.3   -1.05 26.05 86.3
      -1.05 28.95 121.3   -1.05 28.95 101.3   -1.05 28.95 86.3
      1.05 -28.95 121.3   1.05 -28.95 101.3   1.05 -28.95 86.3
      1.05 -26.05 121.3   1.05 -26.05 101.3   1.05 -26.05 86.3
      1.05 -21.05 121.3   1.05 -21.05 101.3   1.05 -21.05 86.3
      1.05 -11.05 121.3   1.05 -11.05 101.3   1.05 -11.05 86.3
      1.05 -1.05 121.3   1.05 -1.05 101.3   1.05 -1.05 86.3
      1.05 1.05 121.3   1.05 1.05 101.3   1.05 1.05 86.3
      1.05 11.05 121.3   1.05 11.05 101.3   1.05 11.05 86.3
      1.05 21.05 121.3   1.05 21.05 101.3   1.05 21.05 86.3
      1.05 26.05 121.3   1.05 26.05 101.3   1.05 26.05 86.3
      1.05 28.95 121.3   1.05 28.95 101.3   1.05 28.95 86.3
      11.05 -28.95 121.3   11.05 -28.95 101.3   11.05 -28.95 86.3
      11.05 -26.05 121.3   11.05 -26.05 101.3   11.05 -26.05 86.3
      11.05 -21.05 121.3   11.05 -21.05 101.3   11.05 -21.05 86.3
      11.05 -11.05 121.3   11.05 -11.05 101.3   11.05 -11.05 86.3
      11.05 -1.05 121.3   11.05 -1.05 101.3   11.05 -1.05 86.3
      11.05 1.05 121.3   11.05 1.05 101.3   11.05 1.05 86.3
      11.05 11.05 121.3   11.05 11.05 101.3   11.05 11.05 86.3
      11.05 21.05 121.3   11.05 21.05 101.3   11.05 21.05 86.3
      11.05 26.05 121.3   11.05 26.05 101.3   11.05 26.05 86.3
      11.05 28.95 121.3   11.05 28.95 101.3   11.05 28.95 86.3
      21.05 -28.95 121.3   21.05 -28.95 101.3   21.05 -28.95 86.3
      21.05 -26.05 121.3   21.05 -26.05 101.3   21.05 -26.05 86.3
      21.05 -21.05 121.3   21.05 -21.05 101.3   21.05 -21.05 86.3
      21.05 -11.05 121.3   21.05 -11.05 101.3   21.05 -11.05 86.3
      21.05 -1.05 121.3   21.05 -1.05 101.3   21.05 -1.05 86.3
      21.05 1.05 121.3   21.05 1.05 101.3   21.05 1.05 86.3
      21.05 11.05 121.3   21.05 11.05 101.3   21.05 11.05 86.3
      21.05 21.05 121.3   21.05 21.05 101.3   21.05 21.05 86.3
      21.05 26.05 121.3   21.05 26.05 101.3   21.05 26.05 86.3
      21.05 28.95 121.3   21.05 28.95 101.3   21.05 28.95 86.3
      26.05 -28.95 121.3   26.05 -28.95 101.3   26.05 -28.95 86.3
      26.05 -26.05 121.3   26.05 -26.05 101.3   26.05 -26.05 86.3
      26.05 -21.05 121.3   26.05 -21.05 101.3   26.05 -21.05 86.3
      26.05 -11.05 121.3   26.05 -11.05 101.3   26.05 -11.05 86.3
      26.05 -1.05 121.3   26.05 -1.05 101.3   26.05 -1.05 86.3
      26.05 1.05 121.3   26.05 1.05 101.3   26.05 1.05 86.3
      26.05 11.05 121.3   26.05 11.05 101.3   26.05 11.05 86.3
      26.05 21.05 121.3   26.05 21.05 101.3   26.05 21.05 86.3
      26.05 26.05 121.3   26.05 26.05 101.3   26.05 26.05 86.3
      26.05 28.95 121.3   26.05 28.95 101.3   26.05 28.95 86.3
      28.95 -28.95 121.3   28.95 -28.95 101.3   28.95 -28.95 86.3
      28.95 -26.05 121.3   28.95 -26.05 101.3   28.95 -26.05 86.3
      28.95 -21.05 121.3   28.95 -21.05 101.3   28.95 -21.05 86.3
      28.95 -11.05 121.3   28.95 -11.05 101.3   28.95 -11.05 86.3
      28.95 -1.05 121.3   28.95 -1.05 101.3   28.95 -1.05 86.3
      28.95 1.05 121.3   28.95 1.05 101.3   28.95 1.05 86.3
      28.95 11.05 121.3   28.95 11.05 101.3   28.95 11.05 86.3
      28.95 21.05 121.3   28.95 21.05 101.3   28.95 21.05 86.3
      28.95 26.05 121.3   28.95 26.05 101.3   28.95 26.05 86.3
      28.95 28.95 121.3   28.95 28.95 101.3   28.95 28.95 86.3
      -28.95 -28.95 71.3   -28.95 -28.95 63.15   -28.95 -28.95 55
      -28.95 -26.05 71.3   -28.95 -26.05 63.15   -28.95 -26.05 55
      -28.95 -21.05 71.3   -28.95 -21.05 63.15   -28.95 -21.05 55
      -28.95 -11.05 71.3   -28.95 -11.05 63.15   -28.95 -11.05 55
      -28.95 -1.05 71.3   -28.95 -1.05 63.15   -28.95 -1.05 55
      -28.95 1.05 71.3   -28.95 1.05 63.15   -28.95 1.05 55
      -28.95 11.05 71.3   -28.95 11.05 63.15   -28.95 11.05 55
      -28.95 21.05 71.3   -28.95 21.05 63.15   -28.95 21.05 55
      -28.95 26.05 71.3   -28.95 26.05 63.15   -28.95 26.05 55
      -28.95 28.95 71.3   -28.95 28.95 63.15   -28.95 28.95 55
      -26.05 -28.95 71.3   -26.05 -28.95 63.15   -26.05 -28.95 55
      -26.05 -26.05 71.3   -26.05 -26.05 63.15   -26.05 -26.05 55
      -26.05 -21.05 71.3   -26.05 -21.05 63.15   -26.05 -21.05 55
      -26.05 -11.05 71.3   -26.05 -11.05 63.15   -26.05 -11.05 55
      -26.05 -1.05 71.3   -26.05 -1.05 63.15   -26.05 -1.05 55
      -26.05 1.05 71.3   -26.05 1.05 63.15   -26.05 1.05 55
      -26.05 11.05 71.3   -26.05 11.05 63.15   -26.05 11.05 55
      -26.05 21.05 71.3   -26.05 21.05 63.15   -26.05 21.05 55
      -26.05 26.05 71.3   -26.05 26.05 63.15   -26.05 26.05 55
      -26.05 28.95 71.3   -26.05 28.95 63.15   -26.05 28.95 55
      -21.05 -28.95 71.3   -21.05 -28.95 63.15   -21.05 -28.95 55
      -21.05 -26.05 71.3   -21.05 -26.05 63.15   -21.05 -26.05 55
      -21.05 -21.05 71.3   -21.05 -21.05 63.15   -21.05 -21.05 55
      -21.05 -11.05 71.3   -21.05 -11.05 63.15   -21.05 -11.05 55
      -21.05 -1.05 71.3   -21.05 -1.05 63.15   -21.05 -1.05 55
      -21.05 1.05 71.3   -21.05 1.05 63.15   -21.05 1.05 55
      -21.05 11.05 71.3   -21.05 11.05 63.15   -21.05 11.05 55
      -21.05 21.05 71.3   -21.05 21.05 63.15   -21.05 21.05 55
      -21.05 26.05 71.3   -21.05 26.05 63.15   -21.05 26.05 55
      -21.05 28.95 71.3   -21.05 28.95 63.15   -21.05 28.95 55
      -11.05 -28.95 71.3   -11.05 -28.95 63.15   -11.05 -28.95 55
      -11.05 -26.05 71.3   -11.05 -26.05 63.15   -11.05 -26.05 55
      -11.05 -21.05 71.3   -11.05 -21.05 63.15   -11.05 -21.05 55
      -11.05 -11.05 71.3   -11.05 -11.05 63.15   -11.05 -11.05 55
      -11.05 -1.05 71.3   -11.05 -1.05 63.15   -11.05 -1.05 55
      -11.05 1.05 71.3   -11.05 1.05 63.15   -11.05 1.05 55
      -11.05 11.05 71.3   -11.05 11.05 63.15   -11.05 11.05 55
      -11.05 21.05 71.3   -11.05 21.05 63.15   -11.05 21.05 55
      -11.05 26.05 71.3   -11.05 26.05 63.15   -11.05 26.05 55
      -11.05 28.95 71.3   -11.05 28.95 63.15   -11.05 28.95 55
      -1.05 -28.95 71.3   -1.05 -28.95 63.15   -1.05 -28.95 55
      -1.05 -26.05 71.3   -1.05 -26.05 63.15   -1.05 -26.05 55
      -1.05 -21.05 71.3   -1.05 -21.05 63.15   -1.05 -21.05 55
      -1.05 -11.05 71.3   -1.05 -11.05 63.15   -1.05 -11.05 55
      -1.05 -1.05 71.3   -1.05 -1.05 63.15   -1.05 -1.05 55
      -1.05 1.05 71.3   -1.05 1.05 63.15   -1.05 1.05 55
      -1.05 11.05 71.3   -1.05 11.05 63.15   -1.05 11.05 55
      -1.05 21.05 71.3   -1.05 21.05 63.15   -1.05 21.05 55
      -1.05 26.05 71.3   -1.05 26.05 63.15   -1.05 26.05 55
      -1.05 28.95 71.3   -1.05 28.95 63.15   -1.05 28.95 55
      1.05 -28.95 71.3   1.05 -28.95 63.15   1.05 -28.95 55
      1.05 -26.05 71.3   1.05 -26.05 63.15   1.05 -26.05 55
      1.05 -21.05 71.3   1.05 -21.05 63.15   1.05 -21.05 55
      1.05 -11.05 71.3   1.05 -11.05 63.15   1.05 -11.05 55
      1.05 -1.05 71.3   1.05 -1.05 63.15   1.05 -1.05 55
      1.05 1.05 71.3   1.05 1.05 63.15   1.05 1.05 55
      1.05 11.05 71.3   1.05 11.05 63.15   1.05 11.05 55
      1.05 21.05 71.3   1.05 21.05 63.15   1.05 21.05 55
      1.05 26.05 71.3   1.05 26.05 63.15   1.05 26.05 55
      1.05 28.95 71.3   1.05 28.95 63.15   1.05 28.95 55
      11.05 -28.95 71.3   11.05 -28.95 63.15   11.05 -28.95 55
      11.05 -26.05 71.3   11.05 -26.05 63.15   11.05 -26.05 55
      11.05 -21.05 71.3   11.05 -21.05 63.15   11.05 -21.05 55
      11.05 -11.05 71.3   11.05 -11.05 63.15   11.05 -11.05 55
      11.05 -1.05 71.3   11.05 -1.05 63.15   11.05 -1.05 55
      11.05 1.05 71.3   11.05 1.05 63.15   11.05 1.05 55
      11.05 11.05 71.3   11.05 11.05 63.15   11.05 11.05 55
      11.05 21.05 71.3   11.05 21.05 63.15   11.05 21.05 55
      11.05 26.05 71.3   11.05 26.05 63.15   11.05 26.05 55
      11.05 28.95 71.3   11.05 28.95 63.15   11.05 28.95 55
      21.05 -28.95 71.3   21.05 -28.95 63.15   21.05 -28.95 55
      21.05 -26.05 71.3   21.05 -26.05 63.15   21.05 -26.05 55
      21.05 -21.05 71.3   21.05 -21.05 63.15   21.05 -21.05 55
      21.05 -11.05 71.3   21.05 -11.05 63.15   21.05 -11.05 55
      21.05 -1.05 71.3   21.05 -1.05 63.15   21.05 -1.05 55
      21.05 1.05 71.3   21.05 1.05 63.15   21.05 1.05 55
      21.05 11.05 71.3   21.05 11.05 63.15   21.05 11.05 55
      21.05 21.05 71.3   21.05 21.05 63.15   21.05 21.05 55
      21.05 26.05 71.3   21.05 26.05 63.15   21.05 26.05 55
      21.05 28.95 71.3   21.05 28.95 63.15   21.05 28.95 55
      26.05 -28.95 71.3   26.05 -28.95 63.15   26.05 -28.95 55
      26.05 -26.05 71.3   26.05 -26.05 63.15   26.05 -26.05 55
      26.05 -21.05 71.3   26.05 -21.05 63.15   26.05 -21.05 55
      26.05 -11.05 71.3   26.05 -11.05 63.15   26.05 -11.05 55
      26.05 -1.05 71.3   26.05 -1.05 63.15   26.05 -1.05 55
      26.05 1.05 71.3   26.05 1.05 63.15   26.05 1.05 55
      26.05 11.05 71.3   26.05 11.05 63.15   26.05 11.05 55
      26.05 21.05 71.3   26.05 21.05 63.15   26.05 21.05 55
      26.05 26.05 71.3   26.05 26.05 63.15   26.05 26.05 55
      26.05 28.95 71.3   26.05 28.95 63.15   26.05 28.95 55
      28.95 -28.95 71.3   28.95 -28.95 63.15   28.95 -28.95 55
      28.95 -26.05 71.3   28.95 -26.05 63.15   28.95 -26.05 55
      28.95 -21.05 71.3   28.95 -21.05 63.15   28.95 -21.05 55
      28.95 -11.05 71.3   28.95 -11.05 63.15   28.95 -11.05 55
      28.95 -1.05 71.3   28.95 -1.05 63.15   28.95 -1.05 55
      28.95 1.05 71.3   28.95 1.05 63.15   28.95 1.05 55
      28.95 11.05 71.3   28.95 11.05 63.15   28.95 11.05 55
      28.95 21.05 71.3   28.95 21.05 63.15   28.95 21.05 55
      28.95 26.05 71.3   28.95 26.05 63.15   28.95 26.05 55
      28.95 28.95 71.3   28.95 28.95 63.15   28.95 28.95 55
      -28.95 -28.95 40   -28.95 -28.95 25   -28.95 -28.95 5
      -28.95 -26.05 40   -28.95 -26.05 25   -28.95 -26.05 5
      -28.95 -21.05 40   -28.95 -21.05 25   -28.95 -21.05 5
      -28.95 -11.05 40   -28.95 -11.05 25   -28.95 -11.05 5
      -28.95 -1.05 40   -28.95 -1.05 25   -28.95 -1.05 5
      -28.95 1.05 40   -28.95 1.05 25   -28.95 1.05 5
      -28.95 11.05 40   -28.95 11.05 25   -28.95 11.05 5
      -28.95 21.05 40   -28.95 21.05 25   -28.95 21.05 5
      -28.95 26.05 40   -28.95 26.05 25   -28.95 26.05 5
      -28.95 28.95 40   -28.95 28.95 25   -28.95 28.95 5
      -26.05 -28.95 40   -26.05 -28.95 25   -26.05 -28.95 5
      -26.05 -26.05 40   -26.05 -26.05 25   -26.05 -26.05 5
      -26.05 -21.05 40   -26.05 -21.05 25   -26.05 -21.05 5
      -26.05 -11.05 40   -26.05 -11.05 25   -26.05 -11.05 5
      -26.05 -1.05 40   -26.05 -1.05 25   -26.05 -1.05 5
      -26.05 1.05 40   -26.05 1.05 25   -26.05 1.05 5
      -26.05 11.05 40   -26.05 11.05 25   -26.05 11.05 5
      -26.05 21.05 40   -26.05 21.05 25   -26.05 21.05 5
      -26.05 26.05 40   -26.05 26.05 25   -26.05 26.05 5
      -26.05 28.95 40   -26.05 28.95 25   -26.05 28.95 5
      -21.05 -28.95 40   -21.05 -28.95 25   -21.05 -28.95 5
      -21.05 -26.05 40   -21.05 -26.05 25   -21.05 -26.05 5
      -21.05 -21.05 40   -21.05 -21.05 25   -21.05 -21.05 5
      -21.05 -11.05 40   -21.05 -11.05 25   -21.05 -11.05 5
      -21.05 -1.05 40   -21.05 -1.05 25   -21.05 -1.05 5
      -21.05 1.05 40   -21.05 1.05 25   -21.05 1.05 5
      -21.05 11.05 40   -21.05 11.05 25   -21.05 11.05 5
      -21.05 21.05 40   -21.05 21.05 25   -21.05 21.05 5
      -21.05 26.05 40   -21.05 26.05 25   -21.05 26.05 5
      -21.05 28.95 40   -21.05 28.95 25   -21.05 28.95 5
      -11.05 -28.95 40   -11.05 -28.95 25   -11.05 -28.95 5
      -11.05 -26.05 40   -11.05 -26.05 25   -11.05 -26.05 5
      -11.05 -21.05 40   -11.05 -21.05 25   -11.05 -21.05 5
      -11.05 -11.05 40   -11.05 -11.05 25   -11.05 -11.05 5
      -11.05 -1.05 40   -11.05 -1.05 25   -11.05 -1.05 5
      -11.05 1.05 40   -11.05 1.05 25   -11.05 1.05 5
      -11.05 11.05 40   -11.05 11.05 25   -11.05 11.05 5
      -11.05 21.05 40   -11.05 21.05 25   -11.05 21.05 5
      -11.05 26.05 40   -11.05 26.05 25   -11.05 26.05 5
      -11.05 28.95 40   -11.05 28.95 25   -11.05 28.95 5
      -1.05 -28.95 40   -1.05 -28.95 25   -1.05 -28.95 5
      -1.05 -26.05 40   -1.05 -26.05 25   -1.05 -26.05 5
      -1.05 -21.05 40   -1.05 -21.05 25   -1.05 -21.05 5
      -1.05 -11.05 40   -1.05 -11.05 25   -1.05 -11.05 5
      -1.05 -1.05 40   -1.05 -1.05 25   -1.05 -1.05 5
      -1.05 1.05 40   -1.05 1.05 25   -1.05 1.05 5
      -1.05 11.05 40   -1.05 11.05 25   -1.05 11.05 5
      -1.05 21.05 40   -1.05 21.05 25   -1.05 21.05 5
      -1.05 26.05 40   -1.05 26.05 25   -1.05 26.05 5
      -1.05 28.95 40   -1.05 28.95 25   -1.05 28.95 5
      1.05 -28.95 40   1.05 -28.95 25   1.05 -28.95 5
      1.05 -26.05 40   1.05 -26.05 25   1.05 -26.05 5
      1.05 -21.05 40   1.05 -21.05 25   1.05 -21.05 5
      1.05 -11.05 40   1.05 -11.05 25   1.05 -11.05 5
      1.05 -1.05 40   1.05 -1.05 25   1.05 -1.05 5
      1.05 1.05 40   1.05 1.05 25   1.05 1.05 5
      1.05 11.05 40   1.05 11.05 25   1.05 11.05 5
      1.05 21.05 40   1.05 21.05 25   1.05 21.05 5
      1.05 26.05 40   1.05 26.05 25   1.05 26.05 5
      1.05 28.95 40   1.05 28.95 25   1.05 28.95 5
      11.05 -28.95 40   11.05 -28.95 25   11.05 -28.95 5
      11.05 -26.05 40   11.05 -26.05 25   11.05 -26.05 5
      11.05 -21.05 40   11.05 -21.05 25   11.05 -21.05 5
      11.05 -11.05 40   11.05 -11.05 25   11.05 -11.05 5
      11.05 -1.05 40   11.05 -1.05 25   11.05 -1.05 5
      11.05 1.05 40   11.05 1.05 25   11.05 1.05 5
      11.05 11.05 40   11.05 11.05 25   11.05 11.05 5
      11.05 21.05 40   11.05 21.05 25   11.05 21.05 5
      11.05 26.05 40   11.05 26.05 25   11.05 26.05 5
      11.05 28.95 40   11.05 28.95 25   11.05 28.95 5
      21.05 -28.95 40   21.05 -28.95 25   21.05 -28.95 5
      21.05 -26.05 40   21.05 -26.05 25   21.05 -26.05 5
      21.05 -21.05 40   21.05 -21.05 25   21.05 -21.05 5
      21.05 -11.05 40   21.05 -11.05 25   21.05 -11.05 5
      21.05 -1.05 40   21.05 -1.05 25   21.05 -1.05 5
      21.05 1.05 40   21.05 1.05 25   21.05 1.05 5
      21.05 11.05 40   21.05 11.05 25   21.05 11.05 5
      21.05 21.05 40   21.05 21.05 25   21.05 21.05 5
      21.05 26.05 40   21.05 26.05 25   21.05 26.05 5
      21.05 28.95 40   21.05 28.95 25   21.05 28.95 5
      26.05 -28.95 40   26.05 -28.95 25   26.05 -28.95 5
      26.05 -26.05 40   26.05 -26.05 25   26.05 -26.05 5
      26.05 -21.05 40   26.05 -21.05 25   26.05 -21.05 5
      26.05 -11.05 40   26.05 -11.05 25   26.05 -11.05 5
      26.05 -1.05 40   26.05 -1.05 25   26.05 -1.05 5
      26.05 1.05 40   26.05 1.05 25   26.05 1.05 5
      26.05 11.05 40   26.05 11.05 25   26.05 11.05 5
      26.05 21.05 40   26.05 21.05 25   26.05 21.05 5
      26.05 26.05 40   26.05 26.05 25   26.05 26.05 5
      26.05 28.95 40   26.05 28.95 25   26.05 28.95 5
      28.95 -28.95 40   28.95 -28.95 25   28.95 -28.95 5
      28.95 -26.05 40   28.95 -26.05 25   28.95 -26.05 5
      28.95 -21.05 40   28.95 -21.05 25   28.95 -21.05 5
      28.95 -11.05 40   28.95 -11.05 25   28.95 -11.05 5
      28.95 -1.05 40   28.95 -1.05 25   28.95 -1.05 5
      28.95 1.05 40   28.95 1.05 25   28.95 1.05 5
      28.95 11.05 40   28.95 11.05 25   28.95 11.05 5
      28.95 21.05 40   28.95 21.05 25   28.95 21.05 5
      28.95 26.05 40   28.95 26.05 25   28.95 26.05 5
      28.95 28.95 40   28.95 28.95 25   28.95 28.95 5
c
"; }

if ($mode eq 'dose') {
    print FOUT "nps 2000000
c Source Cards---------------------------------------------------
SDEF POS=0 0 45.72 RAD=D2 AXS=0 0 1 EXT=D3 ERG=D1 PAR=N
CTME=30
c Source Energies------------------------------------------------
SI1  0 0.25 0.5 0.75 1 1.25 1.5 1.75 2 2.25 2.5 2.75 3 3.25 3.5 3.75
     4 4.25 4.5 4.75 5 5.25 5.5 5.75 6 6.25 6.5 6.75 7 7.25 7.5 7.75
     8 8.25 8.5 8.75 9 9.25 9.5 9.75 10 10.25 10.5 10.75 11 11.25 11.5 11.75 12
SP1 D 0 2.39E-4 4.95E-3 1.29E-2 1.69E-2 1.73E-2 1.54E-2 1.17E-2
        1.59E-2 1.93E-2 2.15E-2 2.62E-2 3.84E-2 4.96E-2 5.22E-2 5.01E-2
        4.72E-2 4.49E-2 4.32E-2 4.13E-2 3.89E-2 3.35E-2 2.76E-2 2.49E-2
        2.40E-2 2.09E-2 2.12E-2 2.39E-2 2.50E-2 2.50E-2 2.49E-2 2.43E-2
        2.30E-2 2.11E-2 1.94E-2 1.82E-2 1.75E-2 1.67E-2 1.47E-2 1.13E-2
        7.08E-3 3.98E-3 2.57E-3 1.34E-3 4.27E-4 5.93E-6 1.23E-8 9.78E-9 7.74E-9
c Radius Distribution---------------------------------------------
SI2 H 0 1.25
SP2 -21 1
c EXT Distribution------------------------------------------------
SI3 H 0 5.7
SP3 -21 1
c
"; }

close(FOUT);

