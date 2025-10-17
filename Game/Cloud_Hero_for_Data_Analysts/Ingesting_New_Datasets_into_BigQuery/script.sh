#!/bin/bash
MY_PROJECT=$(gcloud config get-value project)
bq mk ecommerce
bq load --autodetect --source_format=CSV ecommerce.products ./products.csv
bq query --use_legacy_sql=false <<EOF
#standardSQL
SELECT
  *
FROM
  ecommerce.products
ORDER BY
  stockLevel DESC
LIMIT  5
EOF
bq load --autodetect -write_disposition=WRITE_TRUNCATE --source_format=CSV ecommerce.products gs://spls/gsp411/exports/products.csv
bq query --use_legacy_sql=false <<EOF
#standardSQL
SELECT
  *,
  SAFE_DIVIDE(orderedQuantity,stockLevel) AS ratio
FROM
  ecommerce.products
WHERE
# include products that have been ordered and
# are 80% through their inventory
orderedQuantity > 0
AND SAFE_DIVIDE(orderedQuantity,stockLevel) >= .8
ORDER BY
  restockingLeadTime DESC
EOF
echo "What is the link"
read link
bq mk --external_table_definition='ecommerce.products_comments@Drive=[{"sourceFormat":"GOOGLE_SHEETS","sourceUris":["$link"],"headers":1}]'
bq query --use_legacy_sql=false <<EOF
#standardSQL
SELECT * FROM ecommerce.products_comments WHERE comments IS NOT NULL
EOF