FROM wawa64/dev-base:latest
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install ninja-build gettext libtool \
    libtool-bin autoconf automake cmake g++ pkg-config unzip curl build-essential \
    libreadline-dev wget dos2unix
WORKDIR /app
COPY ./scripts/install-lua.sh ./scripts/install-luarocks.sh /app/
# all this should be one command line
RUN dos2unix --oldfile /app/* && \
    ./install-lua.sh && \
    ./install-luarocks.sh
WORKDIR /src