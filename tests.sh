#!/bin/sh

# anzahl der Versuche
count=$1

#memory=0
tsc=0
branchmiss=0
l2access=0
instructions=0
cycleusr=0
cyclesys=0

# durchlaufen und aufsummieren
for (( i=1; i <= count; i++ ))
do
	# test durchführen
	perfex -e 0x4100c5 -e 0x414F2E -e 0x430000@0x40000000 -e 0x410000@0x40000001 -e 0x420000@0x40000002 shortest-path < input-bench-littleendian >/dev/null 2>tempfoo
	# speicher
	data=`sed '/^[^0123456789].*[0123456789]$/d' tempfoo`
	#memory=`expr $memory + $data`
#	memory=`sed 's/event//g' tempfoo | sed 's/tsc//'`
	# tsc aufaddieren
	data=`sed -n '/^tsc.*[0123456789]$/p' tempfoo | sed 's/^.* //g'`
	tsc=`expr $tsc + $data`
	# branchmisses aufaddieren
	data=`sed -n '/0x004100C5.*[0123456789]$/p' tempfoo | sed 's/^.* //g'`
	branchmiss=`expr $branchmiss + $data`
	# l2 cache accesses aufaddieren
	data=`sed -n '/0x00414F2E.*[0123456789]$/p' tempfoo | sed 's/^.* //g'`
	l2access=`expr $l2access + $data`
	#...
	data=`sed -n '/0x00430000@0x40000000.*[0123456789]$/p' tempfoo | sed 's/^.* //g'`
	instructions=`expr $instructions + $data`
	data=`sed -n '/0x00410000@0x40000001.*[0123456789]$/p' tempfoo | sed 's/^.* //g'`
	cycleusr=`expr $cycleusr + $data`
	data=`sed -n '/0x00420000@0x40000002.*[0123456789]$/p' tempfoo | sed 's/^.* //g'`
	cyclesys=`expr $cyclesys + $data`
	
	#echo "Ergebnis $i:"
	#cat tempfoo
	#echo ""
done

# Durchschnitt bilden
#memory=`expr $memory / $count`
tsc=`expr $tsc / $count`
branchmiss=`expr $branchmiss / $count`
l2access=`expr $l2access / $count`
instructions=`expr $instructions / $count`
cycleusr=`expr $cycleusr / $count`
cyclesys=`expr $cyclesys / $count`

rm tempfoo

#echo "speicher:          $memory"
echo "tsc:               $tsc"
echo "branch misses:     $branchmiss"
echo "L2 Cache accesses: $l2access"
echo "instructions:      $instructions"
echo "cycles(user):      $cycleusr"
echo "cycles(system):    $cyclesys"
