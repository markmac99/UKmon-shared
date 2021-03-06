#!/bin/bash
#
# monthly reporting for UKMON
#
here="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source $here/../config/config.ini >/dev/null 2>&1

source $HOME/venvs/${RMS_ENV}/bin/activate

yr=$2
shwr=$1
lastyr=$((yr-1))

echo getting latest combined files

source ~/.ssh/ukmon-shared-keys
aws s3 sync s3://ukmon-shared/consolidated/ ${RCODEDIR}/DATA/consolidated --exclude 'consolidated/temp/*'
aws s3 sync s3://ukmon-live/ ${RCODEDIR}/DATA/ukmonlive/ --exclude "*" --include "*.csv"

cd ${RCODEDIR}/DATA
echo "Getting single detections and associations for $yr"
cp consolidated/M_${yr}-unified.csv UFO-all-single.csv
cp consolidated/P_${yr}-unified.csv RMS-all-single.csv

echo "getting RMS single-station shower associations for $yr"
echo "ID,Y,M,D,h,m,s,Shwr" > RMS-assoc-single.csv
cat ${RCODEDIR}/DATA/consolidated/A/??????_${yr}* >> RMS-assoc-single.csv

echo "getting matched detections for $yr"
cp $here/templates/UO_header.txt ${RCODEDIR}/DATA/matched/matches-$yr.csv
cat ${RCODEDIR}/DATA/orbits/$yr/csv/$yr*.csv >> ${RCODEDIR}/DATA/matched/matches-$yr.csv

if [ "$shwr" == "QUA" ] ; then
    echo "including previous year to catch early Quadrantids"
    sed '1d' consolidated/M_${lastyr}-unified.csv >> UFO-all-single.csv
    sed '1d' consolidated/P_${lastyr}-unified.csv >> RMS-all-single.csv

    echo "including prev year RMS single-station shower associations"
    cat ${RCODEDIR}/DATA/consolidated/A/??????_${lastyr}* >> RMS-assoc-single.csv

    echo "getting matched detections for $lastyr"
    cp $here/templates/UO_header.txt ${RCODEDIR}/DATA/matched/matches-$lastyr.csv
    cat ${RCODEDIR}/DATA/orbits/$lastyr/csv/$lastyr*.csv >> ${RCODEDIR}/DATA/matched/matches-$lastyr.csv

else
    echo "" >> UFO-all-single.csv
    echo "" >> RMS-all-single.csv
    # not needed for these data echo "" >> RMS-assoc-single.csv
fi 
# merge in the RMS data
cp UFO-all-single.csv UKMON-all-single.csv
python $here/RMStoUFOA.py $SRC/config/config.ini RMS-all-single.csv RMS-assoc-single.csv RMS-UFOA-single.csv $SRC/analysis/templates/
sed '1d' RMS-UFOA-single.csv | sed '1d' >> UKMON-all-single.csv
cp RMS-UFOA-single.csv consolidated/R_${yr}-unified.csv
cp UKMON-all-single.csv consolidated/UKMON-${yr}-single.csv
echo "got relevant data"

lc=$(wc -l ${RCODEDIR}/DATA/matched/matches-$yr.csv | awk '{print $1}')
if [ $lc -gt 1 ] ; then
    cp ${RCODEDIR}/DATA/matched/matches-$yr.csv ${RCODEDIR}/DATA/UKMON-all-matches.csv
else
    cp ${RCODEDIR}/DATA/matched/pre2020/matches-$yr.csv ${RCODEDIR}/DATA/UKMON-all-matches.csv
fi 

if [ "$shwr" == "QUA" ] ; then
    lc=$(wc -l ${RCODEDIR}/DATA/matched/matches-$lastyr.csv | awk '{print $1}')
    if [ $lc -gt 1 ] ; then
        sed '1d' ${RCODEDIR}/DATA/matched/matches-$lastyr.csv >> ${RCODEDIR}/DATA/UKMON-all-matches.csv
    else
        sed '1d' ${RCODEDIR}/DATA/matched/pre2020/matches-$yr.csv >> ${RCODEDIR}/DATA/UKMON-all-matches.csv
    fi 
fi 

cd $here
echo "running $shwr report for $yr"
$here/createReport.sh $shwr $yr $3

