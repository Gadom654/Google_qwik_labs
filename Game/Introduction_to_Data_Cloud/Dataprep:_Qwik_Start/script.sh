#!/bin/bash
export PROJECT_ID=$(gcloud config get-value project)
gcloud storage buckets create gs://$PROJECT_ID-bucket \
    --project=$PROJECT_ID \
    --no-public-access-prevention
gcloud beta services identity create --service=dataprep.googleapis.com
echo "Finish manual steps from 2nd task"
