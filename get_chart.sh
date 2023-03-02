#!/bin/bash

VERSION=$1

if [ -z "$VERSION" ]; then
    echo "Usage: $0 <version>"
    exit 1
fi

helm pull --repo "https://helm.pachyderm.com" pachyderm --version $VERSION

tar -xvf pachyderm-$VERSION.tgz
rm  pachyderm-$VERSION.tgz
