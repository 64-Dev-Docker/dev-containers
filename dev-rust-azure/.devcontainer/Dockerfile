FROM wawa64/dev-rust:latest

COPY library-scripts/* /tmp/library-scripts/
RUN bash /tmp/library-scripts/Azure-Functions-Core.sh \
     && apt-get clean -y \
     && rm -rf /var/lib/apt/lists/* /tmp/library-scripts

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>
