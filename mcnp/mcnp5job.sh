#!/bin/bash
 
#PBS -V
#PBS -q fill
#PBS -l nodes=1:ppn=8

hostname
module unload mpi
module load openmpi
module load MCNP5
#DATAPATH=/opt/MCNP5-1.60/MCNP_DATA/space07xs2
RTP="/tmp/runtp--".`date "+%R%N"`
cd $PBS_O_WORKDIR
mcnp5.mpi TASKS 8 name=lwnusa.inp runtpe=$RTP
grep -a "final result" lwnusa.inpo > done.dat
rm $RTP

