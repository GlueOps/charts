#!/usr/bin/env bash
set -e

export AWS_REGION=us-west-2

for group in `ls -d */`
do
    cd $group
    helm s3 init s3://$S3_BUCKET_NAME/$group && helm repo add $group s3://$S3_BUCKET_NAME/$group

    for D in `ls -d */`
    do
        helm package --dependency-update $D
    done

    for F in `ls -f *.tgz`
    do
        helm s3 push $F $group --ignore-if-exists
    done
done
