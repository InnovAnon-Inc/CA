FROM python:latest

#COPY ./dist/         \
#  /tmp/dist/
#
#RUN pip install      \
#  /tmp/dist/*.whl    \
#&& rm -frv           \
#  /tmp/dist/
RUN pip install teamhack_ca

COPY    ./bin/ \
         /var/teamhack/bin/
COPY    ./lib/ \
         /var/teamhack/lib/
WORKDIR  /var/teamhack
VOLUME ["/var/teamhack/certs"]
VOLUME ["/var/teamhack/crl"]
VOLUME ["/var/teamhack/csr"]
VOLUME ["/var/teamhack/private"]

RUN command -v bin/init_ca
RUN command -v bin/root_ca
RUN command -v bin/intermediate_ca
RUN command -v bin/site
RUN command -v bin/revoke
RUN command -v bin/nuke

ENTRYPOINT [         \
  "/usr/bin/env",    \
  "python",          \
  "-m",              \
  "teamhack_ca"      \
]

EXPOSE 5002/tcp

