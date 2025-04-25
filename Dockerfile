FROM ubuntu:noble

ENV DEBIAN_FRONTEND noninteractive

WORKDIR /workdir

RUN apt-get update \
	&& apt-get -qq install -y apt-utils \
	&& apt-get -qq upgrade -y \
	&& apt-get -qq dist-upgrade -y \
	&& apt-get -qq install -y --no-install-recommends make vim vim-common vim-runtime ssh git wget unzip locales python3-setuptools python3.12 python3-venv python3-pip maven ansible curl tabix vcftools gcc python3-dev jq leiningen \
	&& apt-get autoremove -y \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -fr aws && \
    rm awscliv2.zip && \
    wget -q https://github.com/owlcollab/owltools/releases/download/2020-04-06/owltools -O /usr/local/bin/owltools && \
    chmod +x /usr/local/bin/owltools && \
    wget -q https://s3.amazonaws.com/agr-build-files/jdk-21_linux-x64_bin.tar.gz && \
    tar zxvf jdk-21_linux-x64_bin.tar.gz && \
    mv jdk-21.0.7 /usr/java && \
    rm jdk-21_linux-x64_bin.tar.gz

# Java 14 install for later
#RUN wget -q https://s3.amazonaws.com/agr-build-files/jdk-11.0.5_linux-x64_bin.tar.gz && tar zxvf jdk-11.0.5_linux-x64_bin.tar.gz && mv jdk-11.0.5 /usr/java && rm jdk-11.0.5_linux-x64_bin.tar.gz
#RUN wget -q https://s3.amazonaws.com/agr-build-files/jdk-14_linux-x64_bin.tar.gz && tar zxvf jdk-14_linux-x64_bin.tar.gz && mv jdk-14 /usr/java && rm jdk-14_linux-x64_bin.tar.gz
#RUN wget -q https://s3.amazonaws.com/agr-build-files/jdk-17.0.5_linux-x64_bin.tar.gz && tar zxvf jdk-17.0.5_linux-x64_bin.tar.gz && mv jdk-17.0.5 /usr/java && rm jdk-17.0.5_linux-x64_bin.tar.gz

RUN update-alternatives --install /usr/bin/java java /usr/java/bin/java 2000 && \
    update-alternatives --install /usr/bin/javac javac /usr/java/bin/javac 2000

# Install Miniconda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p /opt/conda && \
    rm /tmp/miniconda.sh

# Update PATH Environment Variable
ENV PATH="/opt/conda/bin:$PATH"

# Setup virtual env
RUN python3.12 -m venv /root/venv && . /root/venv/bin/activate && pip install awsebcli
