#!/bin/bash
MY_PROJECT=$(gcloud config get-value project)
bq mk bqml_lab
echo "Do the rest manualy in BigQuery"