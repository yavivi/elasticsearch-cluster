read -p "DONT FORGET TO CREATE MAPPING!!" ans

curl -XPOST -H "Content-Type: application/x-ndjson" localhost:9200/$1/$2/_bulk --data-binary @$3
