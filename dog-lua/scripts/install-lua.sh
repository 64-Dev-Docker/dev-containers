#! /bin/bash
# install lua
curl -R -O http://www.lua.org/ftp/lua-5.4.2.tar.gz
tar -zxf lua-5.4.2.tar.gz
cd lua-5.4.2
make linux test
make install