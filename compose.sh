#!/bin/sh
set -eu

CACHE=/var/cache/ostree
REPO=/var/tmp/repo

mkdir -p $CACHE
mkdir -p $REPO

rm -Rf $CACHE/*
rm -Rf $REPO/*

if [ ! -d $REPO/objects ]; then
    ostree --repo=$REPO init --mode=archive-z2
fi

rpm-ostree compose tree --unified-core --cachedir=$CACHE --repo=$REPO mto-desktop.yaml

