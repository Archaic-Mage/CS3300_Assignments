#!/bin/sh

make A1.exe

cd test_cases

for i in *.java;
do 
    ../A1.exe < $i > ../results/$i 
    echo "Done file $i"
done;

cd ..

