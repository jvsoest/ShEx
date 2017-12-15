# Shape Expressions docker container

This repository holds the creation of a Shape Expressions docker image. Please find the commands below for execution.
This docker image validates a Shape Expression on a given SPARQL endpoint.

## Running the base container

To configure this image for a specific shape, please fill the /shape-import-dir with the following files:

* shape.shex: the actual shape expression
* startShape.uri: the shape expression which is the root-node to check
* rootQuery.sparql: the SPARQL query to retrieve URIs for root nodes in the endpoint to check

To retrieve the base container, please execute the following command:
```
docker pull jvsoest/shex:latest
```

To configure & run the shape expression, the easiest approach is to mount a host folder to the /shape-import-dir. For example:

```
docker run -t --name shexTest -v c:/tmp/shapedir:/shape-import-dir -v c:/tmp/out:/output-dir -e ENDPOINT=http://as-vate-01.ad.maastro.nl/blazegraph/namespace/thunder/sparql jvsoest/shex:latest
```

## Packaging a configured shape

To create an image with a pre-configured shape, you can execute the following commands:

```
docker run -t --name shexThunder -v c:/tmp/shapedir:/shape-import-dir jvsoest/shex:latest
docker commit shexThunder jvsoest/shex:thunder
```

This code will execute the base shape image, and add the configuration files to this container.
the second line commits this container as a new image (including the configuration).

To run this configured container, you can execute the following line:

```
docker run --rm -t -v c:/tmp/out:/output-dir -e ENDPOINT=http://as-vate-01.ad.maastro.nl/blazegraph/namespace/thunder/sparql jvsoest/shex:thunder
```

## Output of Shape Expression image
When configured correctly, the contents of /output-dir in the container are mapped to a local folder. This folder contains the following items:

* JSON files for every resource which has been evaluated
* A text file containing the list of JSON files which did not have a positive result (shape validation failed)
