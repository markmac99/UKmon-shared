#!/bin/bash
#
# script to update match data each night and then recalc any necessary orbits

here="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

source $here/../config/config.ini >/dev/null 2>&1

source $WEBSITEKEY
echo "getting latest livefeed CSV files"
aws s3 sync s3://ukmon-live/ ${RCODEDIR}/DATA/ukmonlive/ --exclude "*" --include "*.csv"

echo "creating searchable indices"
$SRC/analysis/createSearchable.sh

find $SRC/logs -name "updateSearchIndex*" -mtime +7 -exec rm -f {} \;