#!/bin/bash

URL=localhost:9200/sysstats/cpu

for i in {1..100000}
do

	date=`date -Iseconds`
	record=`sar 1 3 | awk -v ddate=${date} '$1 == "Average:" { print "{ \"datetime\" : \"" ddate "\", \"user\" : " $3 ", \"system\" : " $5 ", \"cpu\" : " 100-$8 " }" }'`

	CMD="curl -XPOST -H 'Content-Type: application/json' '$URL' -d '$record'"
	echo $record
	eval $CMD
done
