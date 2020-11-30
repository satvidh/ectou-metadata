FROM ubuntu:20.04

WORKDIR /app

RUN apt-get update \
    && apt-get install -y iptables

COPY update-iptables.sh /app

RUN chmod +x /app/update-iptables.sh

ENTRYPOINT ["/app/update-iptables.sh"]
