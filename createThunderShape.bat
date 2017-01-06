docker run -t --name shexThunder -v c:/Users/johan.vansoest/Documents/Repositories/SAGE/ShapeExpressions/shapedir:/shape-import-dir jvsoest/shex:latest
docker commit shexThunder jvsoest/shex:thunder
docker rm shexThunder