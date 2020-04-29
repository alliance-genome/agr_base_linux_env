FROM ubuntu:bionic

ENV DEBIAN_FRONTEND noninteractive

WORKDIR /workdir

RUN apt-get update && apt-get -qq install -y apt-utils && apt-get -qq upgrade -y && apt-get -qq dist-upgrade -y

RUN apt-get -qq install -y --no-install-recommends make vim vim-common vim-runtime ssh git wget unzip locales nodejs npm python3.7 python3-pip maven ansible curl python-pip tabix

RUN pip install boto
RUN pip3 install setuptools wheel

RUN ansible-galaxy install akirak.coreos-python

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN npm cache clean -f
RUN npm install -g n
RUN n stable

RUN wget -q https://github.com/owlcollab/owltools/releases/download/2020-04-06/owltools -O /usr/local/bin/owltools && chmod +x /usr/local/bin/owltools

RUN wget -q https://s3.amazonaws.com/agr-build-files/jdk-11.0.5_linux-x64_bin.tar.gz && tar zxvf jdk-11.0.5_linux-x64_bin.tar.gz && mv jdk-11.0.5 /usr/java && rm jdk-11.0.5_linux-x64_bin.tar.gz

#RUN wget -q https://s3.amazonaws.com/agr-build-files/jdk-14_linux-x64_bin.tar.gz
#RUN tar zxvf jdk-14_linux-x64_bin.tar.gz
#RUN mv jdk-14 /usr/java
#RUN rm jdk-14_linux-x64_bin.tar.gz
RUN update-alternatives --install /usr/bin/java java /usr/java/bin/java 2000
RUN update-alternatives --install /usr/bin/javac javac /usr/java/bin/javac 2000

RUN wget -q https://s3.amazonaws.com/agr-build-files/infinispan-server-11.0.0.Dev04.zip && unzip -q infinispan-server-11.0.0.Dev04.zip && rm infinispan-server-11.0.0.Dev04.zip && mv infinispan-server-11.0.0.Dev04 /opt/infinispan

COPY standalone.conf /opt/infinispan/bin
