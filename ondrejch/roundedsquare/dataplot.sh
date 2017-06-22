#!/bin/bash

tabfile="tab.dat"
echo "# pitch[cm]   k_eff sigma_k_eff" >  $tabfile

for d in $(ls -d p_*); do 
    p=$(echo $d|sed -e s/p_//g) 
    keff=$(awk '{print $3" "$4;}' $d/done.dat)
    echo "pitch: $p, keff: $keff"
    echo "$p        $keff" >> $tabfile
done

gnuplot << EOF
set terminal pngcairo size 1200,800 enhanced font "Verdana,14"
set out "study_roundedsquare_pitch.png"
set ytics nomirror
set y2tics 0.1
set xtics 0.1
set grid
set title "Rounded square pitch, 225 rods"
set xlabel "pitch [cm]"
set ylabel "k_{eff}"
set y2label "maximum radius of hole between rods [cm]"

plot [3.95:5.05]"tab.dat" u 1:2:3 w e  tit "k_{eff}", "" w lp notit ls 1, "" u 1:(\$1*sqrt(2)/2 - 1.655) axes x1y2 w l tit "max hole radius"
EOF

