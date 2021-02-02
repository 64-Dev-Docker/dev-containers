FROM ubuntu:20.04
# TODO: move these into a init.sh and execute from the `RUN` below
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install dos2unix git
WORKDIR /app
COPY ./scripts/init.vim ./scripts/install-neovim.sh ./scripts/powerline.sh ./scripts/update-bash.sh /app/
RUN dos2unix --oldfile /app/* && \
    ./install-neovim.sh && \
    ./powerline.sh && \
    ./update-bash.sh
WORKDIR /src
