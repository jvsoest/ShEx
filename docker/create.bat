docker build -t jvsoest/shex:latest ./
docker run -t --name shexTest -v c:/Users/johan.vansoest/Documents/Repositories/SAGE/ShapeExpressions/shapedir:/shape-import-dir -v c:/tmp/out:/output-dir jvsoest/shex:latest

docker commit shexTest jvsoest/shex:thunder
docker rm shexTest