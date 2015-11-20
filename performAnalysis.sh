QUERY=$(<patientQuery.sparql)

curl --verbose --url "http://localhost:9999/bigdata/sparql" -X POST -H "Accept:application/sparql-results+json" --data-urlencode "query=$QUERY" > results.json

Rscript analysis.r

rm results.json

curl --verbose --url "http://as-vate-01.ad.maastro.nl/openrdf-sesame/repositories/cat" -X POST -H "Accept:application/sparql-results+json" --data-urlencode "query=$QUERY" > results.json

Rscript analysis.r

#rm results.json