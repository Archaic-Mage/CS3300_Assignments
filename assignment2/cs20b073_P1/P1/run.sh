#!/bin/sh

javac P1.java

for f in ../../sample_minijava/*.java;
do 
    q="$(basename $f .java)"
    java P1 < $f > ./results/$q.txt
done

find . -name "*.class" | xargs rm
