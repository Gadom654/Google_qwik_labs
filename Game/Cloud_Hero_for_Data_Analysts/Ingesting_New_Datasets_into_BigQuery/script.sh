#!/bin/bash
MY_PROJECT=$(gcloud config get-value project)
bq mk ecommerce
bq load --autodetect --source_format=CSV ecommerce.products ./products.csv
bq load --autodetect --replace --source_format=CSV ecommerce.products gs://spls/gsp411/exports/products.csv
echo "Run query in 4th task manualy and follow 5th task untli link is generated"
echo "What is the link?"
read link
bq mk --external_table_definition='ecommerce.products_comments@Drive=[{"sourceFormat":"GOOGLE_SHEETS","sourceUris":["$link"],"headers":1}]'
bq query --use_legacy_sql=false <<EOF
#standardSQL
SELECT * FROM ecommerce.products_comments WHERE comments IS NOT NULL
EOF