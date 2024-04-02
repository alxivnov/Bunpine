#!/bin/sh

GITHUB="https://github.com"

if [ $(uname -m) == "aarch64" ]; then
	target="arm64_linux"
else
	target="amd64_linux"
fi

upx_bin=upx
upx_ver=${1:-"4.2.2"}
upx_dir=upx-$upx_ver-$target
upx_ext=tar.xz
upx_zip=$upx_dir.$upx_ext
upx_uri=$GITHUB/upx/upx/releases/download/v$upx_ver/$upx_zip


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
