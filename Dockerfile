FROM python:latest

#COPY ./dist/         \
#  /tmp/dist/
#
#RUN pip install      \
#  /tmp/dist/*.whl    \
#&& rm -frv           \
#  /tmp/dist/
RUN pip install teamhack_ca

COPY ./bin \
     ./lib \
      /var/teamhack/
WORKDIR  /var/teamhack
VOLUME ["/var/teamhack/certs"]
VOLUME ["/var/teamhack/crl"]
VOLUME ["/var/teamhack/csr"]
VOLUME ["/var/teamhack/private"]

ENTRYPOINT [         \
  "/usr/bin/env",    \
  "python",          \
  "-m",              \
  "teamhack_ca"      \
]

EXPOSE 5002/tcp

