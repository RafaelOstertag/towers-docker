#!/bin/sh

set -eu

if [ $# -ne 1 ]
then
  echo "$0 <version>" >&2
  exit 1
fi
VERSION=$1

MACHINE=`uname -m`
case "${MACHINE}" in
x86_64)
  PLATFORM="linux/amd64"
  VERSION_SUFFIX="amd64"
  ;;
aarch64)
  PLATFORM="linux/arm64/v8"
  VERSION_SUFFIX="arm64"
  ;;
*)
  echo "${MACHINE} is not supported" >&2
  exit 2
esac

echo "### Building for ${PLATFORM}"

docker buildx build --push --platform "${PLATFORM}" --build-arg VERSION="${VERSION}" -t "rafaelostertag/towers:${VERSION}-${VERSION_SUFFIX}" -f docker/Dockerfile docker
