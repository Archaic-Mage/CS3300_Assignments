#!/bin/sh

javac P4.java
mkdir results

for f in ../../sample_microIR/*.microIR;
do 
    q="$(basename $f .microIR)"
    java P4 < $f > ./results/$q.miniRA
done

find . -name "*.class" | xargs rm