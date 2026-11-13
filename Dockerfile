FROM ubuntu:noble

ENV DEBIAN_FRONTEND noninteractive

WORKDIR /workdir

RUN apt-get update \
	&& apt-get -qq install -y apt-utils \
	&& apt-get -qq upgrade -y \
	&& apt-get -qq dist-upgrade -y \
	&& apt-get -qq install -y --no-install-recommends make vim vim-common vim-runtime ssh git wget unzip locales python3-setuptools python3.12 python3-venv python3-pip maven ansible curl tabix vcftools gcc python3-dev jq leiningen python3-boto3 python3-botocore \
	&& apt-get autoremove -y \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -fr aws && \
    rm awscliv2.zip && \
    wget -q https://s3.amazonaws.com/agr-build-files/jdk-21.0.12.1_linux-aarch64_bin.tar.gz && \
    tar zxvf jdk-21.0.12.1_linux-aarch64_bin.tar.gz && \
    mv jdk-21.0.12.1 /usr/java && \
    rm jdk-21.0.12.1_linux-aarch64_bin.tar.gz

# Java 14 install for later
#RUN wget -q https://s3.amazonaws.com/agr-build-files/jdk-11.0.5_linux-x64_bin.tar.gz && tar zxvf jdk-11.0.5_linux-x64_bin.tar.gz && mv jdk-11.0.5 /usr/java && rm jdk-11.0.5_linux-x64_bin.tar.gz
#RUN wget -q https://s3.amazonaws.com/agr-build-files/jdk-14_linux-x64_bin.tar.gz && tar zxvf jdk-14_linux-x64_bin.tar.gz && mv jdk-14 /usr/java && rm jdk-14_linux-x64_bin.tar.gz
#RUN wget -q https://s3.amazonaws.com/agr-build-files/jdk-17.0.5_linux-x64_bin.tar.gz && tar zxvf jdk-17.0.5_linux-x64_bin.tar.gz && mv jdk-17.0.5 /usr/java && rm jdk-17.0.5_linux-x64_bin.tar.gz

RUN update-alternatives --install /usr/bin/java  java  /usr/java/bin/java 2000 && \
    update-alternatives --set java /usr/java/bin/java && \
    update-alternatives --install /usr/bin/javac javac /usr/java/bin/javac 2000 && \
    update-alternatives --set javac /usr/java/bin/javac

# Install Miniconda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh -O miniconda.sh && \
    bash miniconda.sh -b -p /opt/conda && \
    rm miniconda.sh

# Update PATH Environment Variable
ENV PATH="/opt/conda/bin:$PATH"

# Setup virtual env
RUN python3.12 -m venv /root/venv && . /root/venv/bin/activate && pip install awsebcli boto3 boto

ENV PATH="/root/venv/bin:$PATH"
