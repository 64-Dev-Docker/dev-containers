#! /bin/bash
# install go
# -L follow redirects
# -O use the same name locally
curl -L -O https://golang.org/dl/go1.15.7.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.15.7.linux-amd64.tar.gz

# add to path
echo '# the path to the go executable' >> ~/.profile
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile