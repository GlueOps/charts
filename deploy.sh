#!/usr/bin/env bash
set -e

export AWS_REGION=us-west-2

for group in `ls -d */`
do
    cd $group
    export chart_group=`echo -n $group | tr -d "/"`
    helm s3 init s3://$S3_BUCKET_NAME/$chart_group && helm repo add $chart_group s3://$S3_BUCKET_NAME/$chart_group

    for D in `ls -d */`
    do
        helm package --dependency-update $D
    done

    for F in `ls -f *.tgz`
    do
        helm s3 push $F $chart_group --ignore-if-exists
    done
done
