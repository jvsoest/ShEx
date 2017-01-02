ENDPOINT="http://as-vate-01.ad.maastro.nl/blazegraph/namespace/thunder/sparql"

curl  -X POST $ENDPOINT --data-urlencode 'query=CONSTRUCT WHERE { hint:Query hint:analytic "true" . hint:Query hint:constructDistinctSPO "false" . ?s ?p ?o }' -H 'Accept:text/turtle' > data.ttl
curl  -X POST $ENDPOINT --data-urlencode 'query=PREFIX ncit:<http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#> PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> SELECT ?patient (replace(str(?patient), "^.*/", "") AS ?suffix) WHERE { ?patient rdf:type ncit:C16960 } ' -H 'Accept:text/csv' > uris.csv

dos2unix uris.csv

IFS=","
while read patient suffix
do
	if [ "$patient" = "patient" ]; then 
		continue
	fi
	
	echo "suffix: $suffix"
	node_modules/shex/bin/validate -x /shape.shex -d /data.ttl -s http://johanvansoest.nl/shex/PatientShape -n $patient > /output-dir/$suffix.json
done < uris.csv
