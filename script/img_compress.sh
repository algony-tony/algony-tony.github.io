#!/usr/bin/env bash

# https://www.linuxlinks.com/best-free-open-source-command-line-image-compression-tools/

BaseDIr=~/repos/algony-tony.github.io/assets/img/post
TempDataDIr=~/repos/algony-tony.github.io/temp_data

# jpeg compression
echo "Begin compress jpg"
FilePre="new-"
for imgfile in $( find ${BaseDIr} -type f -iname "*.jpg" );
do
    echo ${imgfile}
    img=`basename ${imgfile}`

    while true; do
        # guetzli
        # ~/software/guetzli-master/bin/Release/guetzli ${BaseDIr}/${img} ${BaseDIr}/${FilePre}${img}

        # mozjpeg
        ~/software/mozjpeg-4.0.3/cjpeg -outfile ${BaseDIr}/${FilePre}${img} ${BaseDIr}/${img}

        pic_size=`stat -c %s ${BaseDIr}/${img}`
        new_pic_size=`stat -c %s ${BaseDIr}/${FilePre}${img}`
        echo "Oirginal   Image size:" ${pic_size}
        echo "Compressed Image size:" ${new_pic_size}
        # 如果压缩后文件更小则采用压缩后图片，否则保持原文件不变并将压缩后文件移入临时目录中
        if [[ ${new_pic_size} -ge ${pic_size} ]]; then
            echo --- Skip, compressed larger
            mv ${BaseDIr}/${FilePre}${img} ${TempDataDIr}/${FilePre}${img}
            break
        else
            mv ${BaseDIr}/${img} ${TempDataDIr}/${img}
            mv ${BaseDIr}/${FilePre}${img} ${BaseDIr}/${img}
            continue
        fi
    done
done

# png compression
echo "Begin compress png"
pngquant --quality=65-80 --ext=.png --force --skip-if-larger ${BaseDIr}/*.png
