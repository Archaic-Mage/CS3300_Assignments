#!/bin/sh

javac P2.java
mkdir results

for f in ../../sample_minijava/*.java;
do 
    q="$(basename $f .java)"
    java P2 < $f > ./results/$q.microIR
done

find . -name "*.class" | xargs rm
