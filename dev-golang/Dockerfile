FROM wawa64/dev-base
WORKDIR /app
COPY ./scripts/install-go.sh /app/
# language specific
RUN ./install-go.sh
WORKDIR /src