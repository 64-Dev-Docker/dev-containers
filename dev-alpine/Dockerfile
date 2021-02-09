# the last version of alpine that is suported by nija build
FROM alpine:3.11
# TODO: move these into a init.sh and execute from the `RUN` below
RUN apk update
RUN apk add dos2unix git bash
WORKDIR /app
COPY ./scripts/init.vim ./scripts/install-neovim.sh ./scripts/powerline.sh ./scripts/update-bash.sh /app/
RUN dos2unix --oldfile /app/* && \
    chmod 744 *.sh && \
    ./powerline.sh && \
    ./update-bash.sh
#     ./install-neovim.sh && \
WORKDIR /src
ENTRYPOINT ["/bin/bash"]
