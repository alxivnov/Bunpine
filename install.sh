#!/bin/sh

GITHUB="https://github.com"



if ([ "$1" == "with-glibc" ] || [ "$2" == "with-glibc" ] || [ "$1" == "only-glibc" ] || [ "$2" == "only-glibc" ]) && [ $(cat /etc/os-release | grep -c "alpine") -gt 0 ]; then
	apk add --no-cache gcompat #libstdc++

	if [ $(uname -m) == "aarch64" ]; then
		# AArch64 https://github.com/SatoshiPortal/alpine-pkg-glibc
		GLIBC="$GITHUB/SatoshiPortal/alpine-pkg-glibc/releases/download/2.33-r0/glibc-2.33-r0-aarch64.apk"
		GLIBC_BIN="$GITHUB/SatoshiPortal/alpine-pkg-glibc/releases/download/2.33-r0/glibc-bin-2.33-r0-aarch64.apk"
		# GLIBC="https://raw.githubusercontent.com/squishyu/alpine-pkg-glibc-aarch64-bin/master/glibc-2.26-r1.apk"
		# GLIBC_BIN="https://raw.githubusercontent.com/squishyu/alpine-pkg-glibc-aarch64-bin/master/glibc-bin-2.26-r1.apk"
	else
		# x86-64 https://github.com/sgerrand/alpine-pkg-glibc
		GLIBC="$GITHUB/sgerrand/alpine-pkg-glibc/releases/download/2.35-r1/glibc-2.35-r1.apk"
		GLIBC_BIN="$GITHUB/sgerrand/alpine-pkg-glibc/releases/download/2.35-r1/glibc-bin-2.35-r1.apk"
	fi

	# if [ $(apk info | grep -c "glibc") -eq 0 ]; then
		wget -O "glibc.apk" "$GLIBC"
		wget -O "glibc-bin.apk" "$GLIBC_BIN"
		apk add --allow-untrusted --force-overwrite --no-cache "glibc.apk" "glibc-bin.apk"
		rm "glibc.apk" "glibc-bin.apk"
	# fi

	if [ "$1" == "only-glibc" ] || [ "$2" == "only-glibc" ]; then
		exit 0
	fi
fi



exe_name=bun
BUNX=bunx

if [ $(uname -m) == "aarch64" ]; then
	target="linux-aarch64"
else
	target="linux-x64"
fi

if [ -f /etc/alpine-release ]; then
	target="$target-musl"
fi

if [ $# -ge 2 ] && ([ $2 == "debug-info" ] || [ $2 == "profile" ]); then
	target=$target-profile
	exe_name=$exe_name-profile
	# BUNX=$BUNX-profile
	info "You requested a debug build of bun. More information will be shown if a crash occurs."
fi

if [ $# -ge 1 ] && ([ $1 != "" ]); then
	if [[ $1 != bun-v* ]]; then
		if [[ $1 == v* ]]; then
			prefix="bun-"
		else
			prefix="bun-v"
		fi
	fi

	bun_uri=$GITHUB/oven-sh/bun/releases/download/${prefix:-}$1/bun-$target.zip
else
	bun_uri=$GITHUB/oven-sh/bun/releases/latest/download/bun-$target.zip
fi

if [ -e /etc/alpine-release ]; then
	apk add --no-cache libstdc++
fi

# if [ $(ls /usr/local/bin | grep -c "$exe_name") -eq 0 ]; then
if ![ -x $exe_name ]; then
	echo $bun_uri
	wget -O "bun.zip" "$bun_uri"
	unzip -o "bun.zip"

	if [ "$1" == "upx" ] || [ "$2" == "upx" ] || [ "$3" == "upx" ]; then
		wget -O - "https://raw.githubusercontent.com/alxivnov/Bunpine/main/upx/install.sh" | sh
		upx --best --lzma --force-overwrite -o "bun-$target/$exe_name" "bun-$target/$exe_name"
		rm "/usr/local/bin/upx"
	fi

	mv "bun-$target/$exe_name" "/usr/local/bin/$exe_name"
	rm -r "bun.zip" "bun-$target"

	ln -s /usr/local/bin/$exe_name /usr/local/bin/$BUNX
fi



which $exe_name
which $BUNX
$exe_name --version
