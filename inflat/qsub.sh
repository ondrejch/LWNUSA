#!/bin/bash

# Jub submission script for TORQUE
# Ondrej Chvala, ochvala@utk.edu
# 2016-08-02
# GNU/GPL

#PBS -V
#PBS -q fill
#PBS -l nodes=1:ppn=8

DECK='lwnusa.inp'

hostname

module load mpi
module load serpent
cd ${PBS_O_WORKDIR}

sss2 -omp 8 $DECK

# We do not need this file, safe disk pace
# rm ${DECK}.out

# Extract useful data
awk 'BEGIN{ORS="\t"} /ANA_KEFF/ || /CONVERSION/ {print $7" "$8;}' ${DECK}_res.m > done.out
grep "set title" $DECK | sed -e s/[a-Z,\"]//g  >> done.out

