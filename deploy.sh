#!/usr/bin/env bash
set -e

for D in `ls -d */`
do
    helm package --dependency-update $D
done

for F in `ls -f *.tgz`
do
    export AWS_REGION=us-west-2
    helm s3 push $F glueops --ignore-if-exists
done