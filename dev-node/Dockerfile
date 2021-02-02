FROM wawa64/dev-base
WORKDIR /app
COPY ./scripts/install-node.sh /app/
# language specific
RUN ./install-node.sh
WORKDIR /src