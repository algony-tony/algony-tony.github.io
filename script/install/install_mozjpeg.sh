
# https://github.com/mozilla/mozjpeg

mkdir ~/software
wget -O ~/software/mozjpeg.zip  https://github.com/mozilla/mozjpeg/archive/refs/tags/v4.0.3.zip
unzip ~/software/mozjpeg.zip -d ~/software/

# Ubuntu
sudo apt install cmake -y

cd ~/software/mozjpeg-4.0.3/
cmake -G"Unix Makefiles" -DENABLE_STATIC=FALSE -DPNG_SUPPORTED=TRUE
make