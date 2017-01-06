#if shape exists (/shape-import-dir is mounted) copy to internal
if [ -f /shape-import-dir/shape.shex ]; then
	cp /shape-import-dir/shape.shex /shape.shex
	cp /shape-import-dir/startShape.uri /startShape.uri
	cp /shape-import-dir/rootQuery.sparql /rootQuery.sparql
	echo "Configuration of shape has been saved."
fi

#Check if endpoint has been given
if [ -z "$ENDPOINT" ]; then
	echo "Environtment variable 'ENDPOINT' not set. Application will exit."
	exit
fi

startShape="$(cat /startShape.uri)"
rootQuery="$(cat /rootQuery.sparql)"

#Query for all data in turtle format
curl  -X POST $ENDPOINT --data-urlencode 'query=CONSTRUCT WHERE { hint:Query hint:analytic "true" . hint:Query hint:constructDistinctSPO "false" . ?s ?p ?o }' -H 'Accept:text/turtle' > data.ttl
#Perform a query to retrieve all patient URIs
curl  -X POST $ENDPOINT --data-urlencode "query=${rootQuery}" -H 'Accept:text/csv' > uris.csv

#convert CSV to unix line endings if endpoint is on Windows server
dos2unix uris.csv

#Loop over all patient URIs, and process shape expression
IFS=","
while read uri suffix
do
	if [ "$uri" = "uri" ]; then 
		continue
	fi
	
	echo "suffix: $suffix"
	node_modules/shex/bin/validate -x /shape.shex -d /data.ttl -s $startShape -n $uri > /output-dir/$suffix.json
done < uris.csv

grep -r "errors" /output-dir > /error_patients.txt

mv /error_patients.txt /output-dir/error_patients.txt