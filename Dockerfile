FROM ubuntu:noble

ENV DEBIAN_FRONTEND noninteractive

WORKDIR /workdir

RUN apt-get update && apt-get -qq install -y apt-utils && apt-get -qq upgrade -y && apt-get -qq dist-upgrade -y

RUN apt-get -qq install -y --no-install-recommends make vim vim-common vim-runtime ssh git wget unzip locales nodejs python3.12 python3.12-venv python3-pip python3-boto python3-boto3 maven ansible curl tabix vcftools gcc python3-dev jq leiningen

RUN pip install --upgrade pip setuptools

# The use of "break system packages" is OK in this case.
RUN pip3 install awscli --break-system-packages 

# Create the virtual environment
RUN python3 -m venv /root/venv

# Upgrade pip and install Python packages within the virtual environment
RUN /root/venv/bin/pip install --upgrade pip && \
    /root/venv/bin/pip install awscli boto3 boto

# Install Dependencies for Conda Installation
RUN apt-get update && \
    apt-get install -y wget bzip2 ca-certificates curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Miniconda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p /opt/conda && \
    rm /tmp/miniconda.sh

# Update PATH Environment Variable
ENV PATH="/opt/conda/bin:$PATH"

RUN wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

RUN wget -q https://github.com/owlcollab/owltools/releases/download/2020-04-06/owltools -O /usr/local/bin/owltools && chmod +x /usr/local/bin/owltools

RUN wget -q https://s3.amazonaws.com/agr-build-files/jdk-17.0.5_linux-x64_bin.tar.gz && tar zxvf jdk-17.0.5_linux-x64_bin.tar.gz && mv jdk-17.0.5 /usr/java && rm jdk-17.0.5_linux-x64_bin.tar.gz

# Java 14 install for later
#RUN wget -q https://s3.amazonaws.com/agr-build-files/jdk-11.0.5_linux-x64_bin.tar.gz && tar zxvf jdk-11.0.5_linux-x64_bin.tar.gz && mv jdk-11.0.5 /usr/java && rm jdk-11.0.5_linux-x64_bin.tar.gz
#RUN wget -q https://s3.amazonaws.com/agr-build-files/jdk-14_linux-x64_bin.tar.gz && tar zxvf jdk-14_linux-x64_bin.tar.gz && mv jdk-14 /usr/java && rm jdk-14_linux-x64_bin.tar.gz

RUN update-alternatives --install /usr/bin/java java /usr/java/bin/java 2000
RUN update-alternatives --install /usr/bin/javac javac /usr/java/bin/javac 2000

#RUN wget -q https://s3.amazonaws.com/agr-build-files/infinispan-server-11.0.0.Dev04.zip && unzip -q infinispan-server-11.0.0.Dev04.zip && rm infinispan-server-11.0.0.Dev04.zip && mv infinispan-server-11.0.0.Dev04 /opt/infinispan
#COPY standalone.conf /opt/infinispan/bin