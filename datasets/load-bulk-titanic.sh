#!/bin/bash


ES_HOST=$1

if [ -z $ES_HOST ]; then
  ES_HOST=localhost
fi

echo Loading into data into elasticsearch cluster $ES_HOST

curl -XPUT http://$ES_HOST:9200/titanic -d '
{
    "mappings" : {
      "passengers" : {
	"_all" : { "enabled": true  },
        "properties" : {
          "age": { "type" : "byte" },
          "bd" : { "type" : "keyword" },
          "ch" : { "type" : "keyword" },
          "lf" : { "type" : "keyword" },
          "nm" : { "type" : "text"  },
          "st" : { "type" : "keyword" },
          "tck": { "type" : "text" },
          "typ": { "type" : "keyword" },
          "url": { "type" : "keyword" }
        }
      }
    }
}'

echo "Loading Bulk of Titanic Passengers"
curl -XPOST $ES_HOST:9200/titanic/passengers/_bulk --data-binary @titanic

