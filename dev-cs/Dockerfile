FROM wawa64/dev-base
WORKDIR /app
COPY ./scripts/install-cs.sh /app/
# language specific
RUN ./install-cs.sh
WORKDIR /src