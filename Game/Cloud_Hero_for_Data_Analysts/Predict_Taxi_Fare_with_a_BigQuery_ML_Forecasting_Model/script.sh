#!/bin/bash
MY_PROJECT=$(gcloud config get-value project)
bq mk --dataset --location=US taxi
echo "Run queries manually"