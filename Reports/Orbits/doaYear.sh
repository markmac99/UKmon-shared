#!/bin/bash
# bash script to reduce a month of data
#
here="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

source $here/orbitsolver.ini > /dev/null 2>&1

for j in {01,02,03,04,05,06,07,08,09,10,11,12}
do
    $here/doaMonth.sh ${i}${j} 
done