#/bin/sh

mkdir microIr miniRa

for f in ./results/*.miniRA;
do 
    q="$(basename $f .miniRA)"
    java -jar ../../kgi.jar < $f > ./miniRa/$q.out
done;

for f in ../../sample_microIR/*.microIR;
do 
    q="$(basename $f .microIR)"
    java -jar ../../pgi.jar < $f > ./microIr/$q.out
done;

for f in ./miniRa/*.out;
do  
    q="$(basename $f .out)"
    diff ./miniRa/$q.out ./microIr/$q.out
done;
