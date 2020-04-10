FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive

WORKDIR /workdir

RUN apt-get update
RUN apt-get -qq install -y apt-utils
RUN apt-get -qq upgrade -y
RUN apt-get -qq dist-upgrade -y

RUN apt-get -qq install -y make vim vim-common vim-runtime git wget unzip locales nodejs npm python3.7 python3-pip maven ansible curl python-pip

RUN pip install boto

RUN ansible-galaxy install akirak.coreos-python

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN npm cache clean -f
RUN npm install -g n
RUN n stable

RUN wget -q https://github.com/owlcollab/owltools/releases/download/2020-04-06/owltools -O /usr/local/bin/owltools
RUN chmod +x /usr/local/bin/owltools

RUN wget -q https://s3.amazonaws.com/agr-build-files/jdk-14_linux-x64_bin.tar.gz
RUN tar zxvf jdk-14_linux-x64_bin.tar.gz
RUN mv jdk-14 /usr/java
RUN rm jdk-14_linux-x64_bin.tar.gz
RUN update-alternatives --install /usr/bin/java java /usr/java/bin/java 2000
RUN update-alternatives --install /usr/bin/javac javac /usr/java/bin/javac 2000

RUN wget -q https://s3.amazonaws.com/agr-build-files/infinispan-server-9.4.15.Final.zip
RUN unzip -q infinispan-server-9.4.15.Final.zip
RUN rm infinispan-server-9.4.15.Final.zip
RUN mv infinispan-server-9.4.15.Final /opt/infinispan
COPY standalone.conf /opt/infinispan/bin
