#/bin/sh

for f in ./results/*.microIR;
do 
    q="$(basename $f .microIR)"
    java -jar ../../pgi.jar < $f
done