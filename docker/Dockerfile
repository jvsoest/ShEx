FROM debian:latest

RUN apt-get update && apt-get -y install vim dos2unix curl
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash -
RUN apt-get update && apt-get -y install nodejs
RUN npm install --save shex
RUN npm install -g mocha
RUN cd /node_modules && npm install chai
RUN mkdir /shape-import-dir
RUN mkdir /root-query-dir
RUN mkdir /output-dir
COPY run.sh /run.sh

CMD ["sh", "run.sh"]