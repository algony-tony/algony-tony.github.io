#!/usr/bin/env bash

# https://www.linuxlinks.com/best-free-open-source-command-line-image-compression-tools/

# 获取脚本所在的目录
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 设置基础路径和临时数据路径
base_dir="$SCRIPT_DIR/../assets/img/post"
temp_data_dir="$SCRIPT_DIR/../temp_data"

# 检查 temp_data_dir 目录是否存在，如果不存在则创建一个
if [ ! -d "$temp_data_dir" ]; then
    mkdir -p "$temp_data_dir"
fi

# 标记是否有图片被压缩
IS_COMPRESSED=0

# JPEG compression
echo "Begin compress jpg"
file_pre="new-"
for imgfile in $(find "$base_dir" -type f -iname "*.jpg"); do
    echo "$imgfile"
    img=$(basename "$imgfile")
    compressed_img="$temp_data_dir/$file_pre$img"

    while true; do
        # Guetzli
        # ~/software/guetzli-master/bin/Release/guetzli "$imgfile" "$compressed_img"

        # MozJPEG
        ~/software/mozjpeg-4.0.3/cjpeg -outfile "$compressed_img" "$imgfile"

        pic_size=$(stat -c %s "$imgfile")
        new_pic_size=$(stat -c %s "$compressed_img")
        echo "Original Image size: $pic_size"
        echo "Compressed Image size: $new_pic_size"
        # 如果压缩后文件更小则采用压缩后图片，否则使用原文件
        if [[ $new_pic_size -ge $pic_size ]]; then
            echo "--- Skip, compressed larger"
            break
        else
            mv "$imgfile" "$temp_data_dir/$img"
            mv "$compressed_img" "$imgfile"
            IS_COMPRESSED=1
            continue
        fi
    done
done

# PNG compression
echo "Begin compress png"
for png_filename in "$base_dir"/*.png; do
    if [ -f "$png_filename" ]; then
        # 使用 pngquant 压缩图片
        pngquant --quality=65-80 --ext=.png --force --skip-if-larger --strip "$png_filename"

        # 检查压缩命令的退出码
        if [ $? -eq 0 ]; then
            IS_COMPRESSED=1
            echo "压缩成功: $png_filename"
        else
            echo "压缩失败或图片已经是最优质的: $png_filename"
        fi
    fi
done

if [ $IS_COMPRESSED -eq 1 ]; then
    exit 1
else
    exit 0
fi