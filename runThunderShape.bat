docker run -i --name shexTest -v c:/tmp/out:/output-dir -e ENDPOINT=http://as-vate-01.ad.maastro.nl/blazegraph/namespace/thunder/sparql jvsoest/shex:thunder
docker rm shexTest