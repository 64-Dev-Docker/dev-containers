#! /bin/bash
# installs the bash powerline
# https://github.com/chris-marsh/pureline
pushd ~

git clone https://github.com/chris-marsh/pureline.git
cp pureline/configs/powerline_full_256col.conf ~/.pureline.conf

echo '# powerline configuration 2021-01-30::wjs' >> ~/.bashrc
echo 'source ~/pureline/pureline ~/.pureline.conf' >> ~/.bashrc

popd