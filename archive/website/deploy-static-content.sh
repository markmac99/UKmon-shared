#!/bin/bash
#
# deployment script for static content on the website
#

here="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

bsjs="$here/templates/searchdialog-template.js"
newf="$here/static_content/data/searchdialog.js"


if [[ "$1" != "dev" && "$1" != "prod" ]] ; then
    echo "usage: ./deploy-static-content.sh dev|prod" 
else
    if [ "$1" == "prod" ] ; then
        newurl='https://lx6dt0krxj.execute-api.eu-west-1.amazonaws.com/prod'
        targbuck=s3://ukmeteornetworkarchive/
        source ~/.ssh/ukmonarchive-keys
    else
        newurl='https://0zbnc358p0.execute-api.eu-west-1.amazonaws.com/test'
        targbuck=s3://mjmm-ukmonarchive.co.uk/
        source ~/.ssh/marks-keys
    fi
    echo "updating searchdialog.js for $1"
    cat $bsjs | sed 's/{{APIURL}}/$newurl/g' > $newf
    echo "syncing to $targbuck"
    aws s3 sync $here/static_content/ $targbuck
    echo "done"
fi