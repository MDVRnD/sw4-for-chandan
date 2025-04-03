#!/usr/bin/env bash

## Any layered model
cat > WUSnoQ.mod << FIN
MODEL.01
Model after     8 iterations
ISOTROPIC
KGS
FLAT EARTH
1-D
CONSTANT VELOCITY
LINE08
LINE09
LINE10
LINE11
  H(KM) VP(KM/S) VS(KM/S) RHO(GM/CC) QP QS ETAP ETAS FREFP FREFS
 1.9000   3.4065   2.0089     2.2150  0  0 0.00 0.00  1.00  1.00
 6.1000   5.5445   3.2953     2.6089  0  0 0.00 0.00  1.00  1.00
13.0000   6.2708   3.7396     2.7812  0  0 0.00 0.00  1.00  1.00
19.0000   6.4075   3.7680     2.8223  0  0 0.00 0.00  1.00  1.00
 0.0000   7.9000   4.6200     3.2760  0  0 0.00 0.00  1.00  1.00
FIN

## Recording at 50 km with Nyquist above 5 Hz
# DIST DT NPTS T0 VRED
echo "50 0.01 4096 0 0" > dfile

## Run
rm -fr hspec96.*
hprep96 -M WUSnoQ.mod -d dfile -HS 10
hspec96

## Output
# Triangle is 2 * L * dt = 2 * 25 * 0.02 = 1
# hpulse96 -V -t -l 25 | f96tosac -G
# Impulse
hpulse96 -V -i | f96tosac -G

## Put in mechanism
# 1e18 nt-m = 1e25 dyne-cm
MOM=1.0e+25
ZSSFILE=`ls *.ZSS | head -1`
PROTO=`basename $ZSSFILE .ZSS`
for MIJ in MXX MXY MXZ MYY MYZ MZZ
do
gsac << EOF
mt to ZNE AZ 0 BAZ 180 ${MIJ} ${MOM} FILE ${PROTO}
w
mv T.Z ${MIJ}_${PROTO}_Z
mv T.N ${MIJ}_${PROTO}_N
mv T.E ${MIJ}_${PROTO}_E
q
EOF
done
FORCE=1.0e+20
for F in FN FE FD
do
gsac << EOF
mt to ZNE AZ 0 BAZ 180 ${F} ${FORCE} FILE ${PROTO}
w
mv T.Z ${F}_${PROTO}_Z
mv T.N ${F}_${PROTO}_N
mv T.E ${F}_${PROTO}_E
q
EOF
done
