#!/usr/bin/env bash
set -e

export AWS_REGION=us-west-2

for group in `ls -d */`
do
    cd $group
    group=`echo -n $group | tr -d "/"`
    helm s3 init s3://$S3_BUCKET_NAME/$group && helm repo add $group s3://$S3_BUCKET_NAME/$group

    for D in `ls -d */`
    do
        helm package --dependency-update $D
    done

    for F in `ls -f *.tgz`
    do
        if [ "$GLUEOPS_ENV" == "development" ]; then
        helm s3 push --acl="public-read" --relative $F $group --force
        fi

        if [ "$GLUEOPS_ENV" == "production" ]; then
        helm s3 push --acl="public-read" --relative $F $group --ignore-if-exists
        fi

    done
    cd ..
done

