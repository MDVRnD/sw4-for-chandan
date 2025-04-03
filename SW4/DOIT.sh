#!/usr/bin/env bash

for MIJ in mxx mxy mxz myy myz mzz
do

cat > ${MIJ}.sw4in << FIN
fileio pfs=1 nwriters=16 path=${MIJ}.dir printcycle=1000
grid x=70e3 y=20e3 z=50e3 h=50
time t=45
block vp=7900.0 vs=4620.0 rho=3276.0 qp=60976 qs=27027
block vp=6407.5 vs=3768.0 rho=2822.3 qp=901 qs=402 z2=40000
block vp=6270.8 vs=3739.6 rho=2781.2 qp=658 qs=293 z2=21000
block vp=5544.5 vs=3295.3 rho=2608.9 qp=287 qs=128 z2=8000
block vp=3406.5 vs=2008.9 rho=2215.0 qp=331 qs=147 z2=1900
source x=10e3 y=10e3 z=10e3 ${MIJ}=1e18 type=Dirac t0=0
#source x=10e3 y=10e3 z=10e3 ${MIJ}=1e18 type=Triangle t0=0 freq=1
#source x=10e3 y=10e3 z=10e3 ${MIJ}=1e18 type=C6SmoothBump t0=0 freq=1
rec x=60e3 y=10e3 z=0 file=rec50 sacformat=1
image mode=s y=10e3 cycle=1
FIN

done

# Reciprocity for Green's functions
for F in fx fy fz
do

cat > ${F}.sw4in << FIN
fileio pfs=1 nwriters=16 path=${F}.dir printcycle=1000
grid x=70e3 y=20e3 z=50e3 h=50
time t=45
block vp=7900.0 vs=4620.0 rho=3276.0 qp=60976 qs=27027
block vp=6407.5 vs=3768.0 rho=2822.3 qp=901 qs=402 z2=40000
block vp=6270.8 vs=3739.6 rho=2781.2 qp=658 qs=293 z2=21000
block vp=5544.5 vs=3295.3 rho=2608.9 qp=287 qs=128 z2=8000
block vp=3406.5 vs=2008.9 rho=2215.0 qp=331 qs=147 z2=1900
source x=60e3 y=10e3 z=0 ${F}=1e18 type=Dirac t0=0
#source x=60e3 y=10e3 z=0 ${F}=1e18 type=Triangle t0=0 freq=1
#source x=60e3 y=10e3 z=0 ${F}=1e18 type=C6SmoothBump t0=0 freq=1
rec x=10e3 y=10e3 z=10e3 file=rec50 sacformat=1 variables=strains
image mode=s y=10e3 cycle=1
FIN

done

# Run using SLRUM with `sbatch runruby.sw4run`
