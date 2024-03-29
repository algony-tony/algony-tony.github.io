
# https://github.com/google/guetzli

mkdir ~/software
wget -O ~/software/guetzli.zip  https://github.com/google/guetzli/archive/master.zip
unzip ~/software/guetzli.zip -d ~/software/

# Ubuntu
sudo apt install libpng-dev -y
sudo apt install pkg-config -y

cd ~/software/guetzli-master/
make
