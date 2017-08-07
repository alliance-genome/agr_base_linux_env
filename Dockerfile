FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y apt-utils
RUN apt-get upgrade -y
RUN apt-get dist-upgrade -y
