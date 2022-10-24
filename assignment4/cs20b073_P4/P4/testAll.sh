#/bin/sh

for f in ./results/*.miniRA;
do 
    q="$(basename $f .miniRA)"
    java -jar ../../kgi.jar < $f
done;
