#!/bin/bash
export PROJECT_ID=$(gcloud config get-value project)
export user=$(gcloud projects get-iam-policy $PROJECT_ID | grep compute@developer.gserviceaccount.com | awk -F ':' '{print $2}')
gcloud services enable dataproc.googleapis.com
gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$user" --role="roles/storage.admin"
echo "What is your region:"
read Region
echo "What is your zone:"
read Zone
gcloud dataproc clusters create example-cluster --enable-component-gateway --region $Region --public-ip-address --zone $Zone --master-machine-type e2-standard-2 \
--master-boot-disk-size 30 --num-workers 2 --worker-machine-type e2-standard-2 --worker-boot-disk-size 30 --image-version 2.2-debian12 --scopes 'https://www.googleapis.com/auth/cloud-platform' --project $PROJECT_ID
gcloud dataproc jobs submit spark \
    --project=$PROJECT_ID \
    --region=$Region \
    --cluster=example-cluster \
    --class=org.apache.spark.examples.SparkPi \
    --jars=file:///usr/lib/spark/examples/jars/spark-examples.jar \
    -- 1000
gcloud dataproc clusters update example-cluster \
    --region=$Region \
    --num-workers=4
