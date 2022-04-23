#!/bin/sh

set -eu

if [ $# -ne 1 ]
then
  echo "$0 <version>" >&2
  exit 1
fi
VERSION=$1
if [ "${VERSION}" = "none" ]
then
  exit 0
fi


IMAGE="rafaelostertag/towers"
IMAGE_VERSIONED="${IMAGE}:${VERSION}"
IMAGE_LATEST="${IMAGE}:latest"

set -x
docker manifest create "${IMAGE_VERSIONED}" \
 --amend "${IMAGE_VERSIONED}-amd64" \
 --amend "${IMAGE_VERSIONED}-arm64"

docker manifest push --purge "${IMAGE_VERSIONED}"

docker manifest create "${IMAGE_LATEST}" \
 --amend "${IMAGE_VERSIONED}-amd64" \
 --amend "${IMAGE_VERSIONED}-arm64"

docker manifest push --purge "${IMAGE_LATEST}"

