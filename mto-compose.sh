#!/bin/sh
set -eu

CACHE=/var/cache/ostree
REPO=/var/tmp/repo
# default to storing locally; can also be "registry:" to directly push
SKOPEO_TARGET="${1:-containers-storage}"

mkdir -p $CACHE

if [ ! -d $REPO/objects ]; then
    ostree --repo=$REPO init --mode=archive-z2
fi

rpm-ostree compose tree --unified-core --cachedir=$CACHE --repo=$REPO mto-desktop.yaml
# HACK: networking in GitHub is a bit flaky, retry a few times
for retry in $(seq 3); do
    rpm-ostree compose container-encapsulate --repo=$REPO mto-desktop ${SKOPEO_TARGET}:ghcr.io/mto79/ostree_mto_workstation:latest && exit 0
    [ "$SKOPEO_TARGET" = registry ] || break
    sleep 30
done
exit 1
