FROM debian:latest

RUN apt-get update && apt-get install -y make

WORKDIR /var/app
COPY . /var/app

RUN make _install_prereq
