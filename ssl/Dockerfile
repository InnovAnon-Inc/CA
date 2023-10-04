FROM ubuntu AS build
RUN apt update
#RUN apt install -y build-essential git
RUN apt install -y openssl netcat

VOLUME ["/etc/ssl/ca"]
#USER ssl-cert
COPY ./ca.sh /
RUN netcat --help
ENTRYPOINT ["/ca.sh"]

