#! /bin/bash
# install lua-rocks
cd /app
wget https://luarocks.org/releases/luarocks-3.5.0.tar.gz
tar zxpf luarocks-3.5.0.tar.gz
cd luarocks-3.5.0
./configure && make && make install
luarocks install luasocket 
luarocks install luacov 
luarocks install cluacov 
luarocks install busted