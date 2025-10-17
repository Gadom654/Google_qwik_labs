#!/bin/bash
MY_PROJECT=$(gcloud config get-value project)
bq mk ecommerce
bq load --autodetect --source_format=CSV ecommerce.products ./products.csv
bq load --autodetect --replace --source_format=CSV ecommerce.products gs://spls/gsp411/exports/products.csv
echo "Do the rest manually"