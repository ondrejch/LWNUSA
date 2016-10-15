#!/bin/bash
#
# Extract KINF data and plot them
# Ondrej Chvala, ochvala@utk.edu, 2016-10-14

OUTFILE="kinf.dat"
rm -f $OUTFILE

for f in $(ls -1 */lwnusa.inp_res.m)
do 
  echo $f
  PITCH=$(echo $f | sed -e s/.lwn.*//g) 
  KEFF=$(grep ANA_KEFF $f | awk '{print $7" "$8}') 
  echo $PITCH $KEFF >> $OUTFILE
done


# Plot the data 
gnuplot -e 'set terminal pngcairo size 1000,800 enhanced font "Verdana,16";
set out "k_inf.png";
set xlabel "fuel pitch [cm]";
set ylabel "k_{inf}";
f(x) = a*(x-d)**2 + b*(x-d)+ c;
a =-0.10994;
b = 0.44637;
c = 0.51195;
d = 1.95157;
fmin = 3.85; fmax = 4.12;
fit [fmin:fmax] f(x) "kinf.dat" u 1:2:($2*$3) via a,b,c,d;
plot [3.795:4.195][:] "kinf.dat" u 1:2:($2*$3) w e ls 1 lc rgb "#ee0101" lw 1.5 notit, x>fmin && x<fmax ? f(x) : 1/0 ls 1 lw 1.7 tit sprintf("k_{inf}^{max} = %6.4f cm", (2*a*d - b)/(2*a)) '

