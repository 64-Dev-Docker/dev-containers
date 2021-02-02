FROM wawa64/dev-node
WORKDIR /app
COPY ./scripts/install-angular.sh /app/
# language specific
RUN ./install-angular.sh
WORKDIR /src