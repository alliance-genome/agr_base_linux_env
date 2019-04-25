FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive

WORKDIR /workdir

RUN apt-get update
RUN apt-get -qq install -y apt-utils
RUN apt-get -qq upgrade -y
RUN apt-get -qq dist-upgrade -y

RUN apt-get -qq install -y make vim vim-common vim-runtime git wget locales nodejs npm python3.7 python3-pip maven

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN npm cache clean -f
RUN npm install -g n
RUN n stable

RUN wget -q http://build.berkeleybop.org/userContent/owltools/owltools -O /usr/local/bin/owltools
RUN chmod +x /usr/local/bin/owltools

RUN wget -q https://s3.amazonaws.com/agr-build-files/jdk-8u144-linux-x64.tar.gz
RUN tar zxf jdk-8u144-linux-x64.tar.gz
RUN mv jdk1.8.0_144 /usr/java
RUN rm jdk-8u144-linux-x64.tar.gz
RUN update-alternatives --install /usr/bin/java java /usr/java/bin/java 2000
RUN update-alternatives --install /usr/bin/javac javac /usr/java/bin/javac 2000
