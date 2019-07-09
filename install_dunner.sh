#!/bin/bash

VERSION='latest'
API_URL="https://api.github.com/repos/leopardslab/dunner/releases"
RELEASES_URL="https://github.com/leopardslab/dunner/releases"

setVersion() {
  VERSION=$(curl --silent "$API_URL/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/');
  if [ "$VERSION" == "" ]; then
    exit 1
  fi
}

binInstall() {
  # Binary installation from the release page.
  ARCH=$(uname -m)
  OS=$(uname -s)

  ver=$(echo $VERSION | sed s/v//g)
  release=$(curl -s ${API_URL} | grep -i "\"name\": \"dunner_${ver}_${OS}_${ARCH}.tar.gz\",")
  if [[ -z $release ]]; then
    echo "OS $OS with $ARCH architecture is not supported corresponding to version $VERSION"
    exit 1
  fi
  if [[ $(which tar) ]]; then
    downloadUrl="${RELEASES_URL}/download/${VERSION}/dunner_${ver}_${OS}_${ARCH}.tar.gz"
    echo "Downloading dunner_${ver}_${OS}_${ARCH}..."
    wget -O "dunner.tar.gz" $downloadUrl 2>/dev/null || curl -o "dunner.tar.gz" -L $downloadUrl
    if [[ $OS == 'Linux' || $OS == 'Darwin' ]]; then
        tar -xf dunner.tar.gz
        cp dunner /usr/local/bin/
    fi
  else
    echo "'tar' command not found..."
    exit 1
  fi
}

setVersion
binInstall