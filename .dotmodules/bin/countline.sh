#!/usr/bin/env bash
#Simple collect the Fujitsu CE project different source code line number
#Author: liqi1031@gmail.com
#Date: Dec 17, 2011
usage()
{
        cat <<EOF
Please enter the directory you want to search and then run it!
Usage: cl.sh [-h|-v] [args1] [args2] [args3]
Options:
           -h           print usage info.
           -v           print version info.
        args1           first match program language e.g c
        args2           second match program language e.g py
        args3           third match program language e.g sh or s
EOF
}
version()
{
        VERSION="1.1"
        echo "countline.sh version $VERSION."
        exit 0
}
calcCodeLine()
{
        destdir=`pwd`
        extname1=$1
        extname2=$2
        extname3=$3
        result=0
        for ext in $extname1 $extname2 $extname3
        do
                linelist=`find $destdir -type f -name "*.$ext" -exec wc -l {} \; |awk '{print $1}' |xargs echo`
                for num in $linelist
                do
                        result=`expr $result + $num`
                done
        done
        return $result
}
#main logic
main()
{
        if [ "x$1" == "x" ] || [ "x$1" == "x-h" ]; then
                usage
                exit 0
        elif [ "x$1" == "x-v" ]; then
                version
                exit 0
        elif [ "x$3" == "x" ] && [ "x$2" == "x" ]; then
                calcCodeLine $1
                echo "Code line number for $1 is $result"
        elif [ "x$3" == "x" ] && [ ! "x$2" == "x" ]; then
                calcCodeLine $1
                echo "Code line number for $1 is $result"
                calcCodeLine $2
                echo "Code line number for $2 is $result"
                calcCodeLine $1 $2
                echo "Total code line number is $result"
        else
                calcCodeLine $1
                echo "Code line number for $1 is $result"
                calcCodeLine $2
                echo "Code line number for $2 is $result"
                calcCodeLine $3
                echo "Code line number for $3 is $result"
                calcCodeLine $1 $2 $3
                echo "Total code line number is $result"
        fi
}
#run main
main $@
