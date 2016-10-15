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
plot [3.35:9.35][:1] "kinf.dat" u 1:2:($2*$3) w e ls 1 lc rgb "#ee0101" lw 1.4  notit'

