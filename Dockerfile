FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y apt-utils
RUN apt-get upgrade -y
RUN apt-get dist-upgrade -y

RUN apt-get install -y make
RUN apt-get install -y vim
RUN apt-get install -y vim-common
RUN apt-get install -y vim-runtime
RUN apt-get install -y git
RUN apt-get install -y wget
