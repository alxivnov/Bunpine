#!/bin/sh

GITHUB="https://github.com"

if [ $(uname -m) = "aarch64" ]; then
	target="arm64_linux"
else
	target="amd64_linux"
fi

upx_bin=upx
upx_ver=${1:-"5.0.1"}
upx_dir=upx-$upx_ver-$target
upx_ext=tar.xz
upx_zip=$upx_dir.$upx_ext
upx_uri=$GITHUB/upx/upx/releases/download/v$upx_ver/$upx_zip


# https://github.com/upx/upx
# wget "https://github.com/upx/upx/releases/download/v4.2.3/upx-4.2.3-amd64_linux.tar.xz"
# tar x -f "upx-4.2.3-amd64_linux.tar.xz"
# mv "upx-4.2.3-amd64_linux/upx" "/usr/local/bin/."
# rm -r "upx-4.2.3-amd64_linux.tar.xz" "upx-4.2.3-amd64_linux"


# if [ $(ls /usr/local/bin | grep -c "$upx_bin") -eq 0 ]; then
	wget "$upx_uri"
	if [ "$upx_ext" = "zip" ]; then
		unzip "$upx_zip"
	else
		tar x -f "$upx_zip"
	fi
	mv "$upx_dir/$upx_bin" "/usr/local/bin/."
	rm -r "$upx_zip" "$upx_dir"
# fi


which $upx_bin
$upx_bin --version
