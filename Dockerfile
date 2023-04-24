FROM ubuntu:lunar

ENV DEBIAN_FRONTEND noninteractive

WORKDIR /workdir

RUN apt-get update && apt-get -qq install -y apt-utils && apt-get -qq upgrade -y && apt-get -qq dist-upgrade -y

RUN apt-get -qq install -y --no-install-recommends make vim vim-common vim-runtime ssh git wget unzip locales nodejs python3.11 python3-pip python3-boto3 maven ansible curl tabix vcftools awscli gcc python3-dev jq leiningen

RUN wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

RUN wget -q https://github.com/owlcollab/owltools/releases/download/2020-04-06/owltools -O /usr/local/bin/owltools && chmod +x /usr/local/bin/owltools

RUN wget -q https://s3.amazonaws.com/agr-build-files/jdk-17.0.5_linux-x64_bin.tar.gz && tar zxvf jdk-17.0.5_linux-x64_bin.tar.gz && mv jdk-17.0.5 /usr/java && rm jdk-17.0.5_linux-x64_bin.tar.gz

RUN update-alternatives --install /usr/bin/java java /usr/java/bin/java 2000
RUN update-alternatives --install /usr/bin/javac javac /usr/java/bin/javac 2000

RUN wget -q https://s3.amazonaws.com/agr-build-files/Miniconda3-py310_22.11.1-1-Linux-x86_64.sh && bash Miniconda3-py310_22.11.1-1-Linux-x86_64.sh -b && rm Miniconda3-py310_22.11.1-1-Linux-x86_64.sh

ENV PATH="${PATH}:/root/miniconda3/bin"
