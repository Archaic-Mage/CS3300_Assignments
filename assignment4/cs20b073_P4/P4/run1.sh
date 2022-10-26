#!/bin/bash

green='\033[0;37m'
red='\033[0;32m'
clear='\033[0m'

if [[ $# == 0 ]]; then
    echo -e "Use -h flag for help"
    exit 1
fi

if [[ $# == 1 ]] && [[ $1 == "-h" ]]; then
    echo "Usage: ./run.sh [flags] <files>"
    echo ""
    echo "flags:"
    echo "-h                show this help message"
    echo "-j2m              convert java to microIR"
    echo "-debug            print my output and correct output, stops as soon as it finds one wrong"
    echo "-notest           gives .RA file but does not test it"
    echo "-nc               does not compile but directly runs the .RA file"
    echo "-d <dir>          to specify directory in which IR files are present, default is IR"
    echo ""
    echo "files:"
    echo ""
    echo "all"
    echo "[1] tests all files in IR folder" 
    echo "[2] if ran with -j2m, will convert all java files to IR and then run all IR files"
    echo ""
    echo "<file>"
    echo "[1] tests tests/input/IR/<file>"
    echo "[2] if ran with -j2m, will convert corresponding file in tests/input/java/ to IR and then run tests/input/IR/<file>"
    exit 1
fi

all=0
j2m=0
debug=0
notest=0
nc=0
stop=0
total=0
pass=0
dset=0
dir="IR"
files=()

for i in $(seq 1 $#)
do
    if [[ ${!i} == "all" ]]; then
        all=1
    elif [[ ${!i} == "-j2m" ]]; then
        j2m=1
    elif [[ ${!i} == "-debug" ]]; then
        debug=1
    elif [[ ${!i} == "-notest" ]]; then
        notest=1
    elif [[ ${!i} == "-nc" ]]; then
        nc=1
    elif [[ ${!i} == "-d" ]]; then
        dset=1
    else
        if [[ $dset == 1 ]]; then
            dir=${!i}
            dset=0
        else
            files+=("${!i}")
        fi
    fi
done

function javaToIr {
    name=$(basename $1 .java)
    java -jar tests/J_M.jar < tests/input/java/$name.java > tests/input/$dir/$name.microIR 2>/dev/null
}

function testIR {
    total=$((total+1))
    echo "------------------------------------------------"
    echo "Processing $1"
    name=$(basename $1 .microIR)
    if [[ $j2m == 1 ]] && [[ -f tests/input/java/$name.java ]] && [[ $nc == 0 ]]; then
        java -jar tests/J_M.jar < tests/input/java/$name.java 1>tests/input/$dir/$name.microIR 2>/dev/null
    fi
    java -jar tests/M_O.jar < tests/input/$dir/$name.microIR 1>tests/output/exec/correct/$name 2>/dev/null
    if [[ $nc == 0 ]]
    then
        if [[ $debug == 0 ]]
        then
            java P4 < tests/input/$dir/$name.microIR 1>tests/output/RA/mine/$name.RA 2>/dev/null
        else
            java P4 < tests/input/$dir/$name.microIR 1>tests/output/RA/mine/$name.RA
        fi
    fi
    if [[ $notest == 0 ]]
    then
        if [[ $debug == 0 ]]
        then
            java -jar tests/R_O.jar < tests/output/RA/mine/$name.RA 1>tests/output/exec/mine/$name 2>/dev/null
        else
            java -jar tests/R_O.jar < tests/output/RA/mine/$name.RA 1>tests/output/exec/mine/$name
        fi
        if [[ $(cat tests/output/exec/correct/$name) == $(cat tests/output/exec/mine/$name) ]]
        then
            pass=$((pass+1))
            echo -e "----->" "${green}Noice${clear}"
        else
            echo -e "----->" "${red}sed${clear}"
            if [[ $debug == 1 ]]; then
                stop=1
                echo "--------------"
                echo "correct:"
                cat tests/output/exec/correct/$name
                echo "--------------"
                echo "mine:"
                cat tests/output/exec/mine/$name
                code -g tests/input/$dir/$name.microIR
                code -g tests/output/RA/mine/$name.RA
            fi
        fi
    fi
}

find . -name "*.class" | xargs rm 2>/dev/null
javac P4.java

if [[ $all == 1 ]]
then
    if [[ $j2m == 1 ]]
    then
        for file in tests/input/java/*.java
        do
            javaToIr $file
        done
    fi
    for i in tests/input/$dir/*.microIR
    do
        if [[ $stop == 1 ]]; then
            exit 1
        fi
        testIR $i
    done
else
    for i in ${files[@]}
    do
        if [[ $stop == 1 ]]; then
            exit 1
        fi
        testIR $i
    done
fi

echo "------------------------------------------------"
echo "Processing done " $pass "/" $total " passed"