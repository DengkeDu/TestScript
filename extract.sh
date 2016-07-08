#!/bin/bash
#This script need two parameters, the first is the input file, the 
#second is the result file which contain the PASS and FAIL result.
if [ ! -e "$2" ]
then
	touch $2
fi
sed -n '/^PASS/p' $1 >> $2
sed -n '/^FAIL/P' $1 >> $2
