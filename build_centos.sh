#!/bin/bash

set -e

case $1 in
5)
  CENTOS_MIRROR=http://mirrors.mit.edu/centos/5/
  EPEL_RELEASE_RPM=http://mirrors.mit.edu/epel/5/x86_64/epel-release-5-4.noarch.rpm
  ;;
6)
  CENTOS_MIRROR=http://mirrors.mit.edu/centos/6/
  EPEL_RELEASE_RPM=http://mirrors.mit.edu/epel/6/x86_64/epel-release-6-8.noarch.rpm
  ;;
*)
  echo "Usage: $0 [5|6]"
  exit 1
  ;;
esac

## requires running as root because filesystem package won't install otherwise,
## giving a cryptic error about /proc, cpio, and utime.  As a result, /tmp
## doesn't exist.
[ $( id -u ) -eq 0 ] || { echo "must be root"; exit 1; }

tmpdir=$( mktemp -d )
trap "echo removing ${tmpdir}; rm -rf ${tmpdir}" EXIT

febootstrap \
    -u ${CENTOS_MIRROR}/updates/x86_64/ \
    -i centos-release \
    -i yum \
    -i iputils \
    -i tar \
    -i which \
    -i ${EPEL_RELEASE_RPM} \
    centos \
    ${tmpdir} \
    ${CENTOS_MIRROR}/os/x86_64/

febootstrap-run ${tmpdir} -- sh -c 'echo "NETWORKING=yes" > /etc/sysconfig/network'

## set timezone of container to UTC
febootstrap-run ${tmpdir} -- ln -f /usr/share/zoneinfo/Etc/UTC /etc/localtime

febootstrap-run ${tmpdir} -- yum clean all

## xz gives the smallest size by far, compared to bzip2 and gzip, by like 50%!
febootstrap-run ${tmpdir} -- tar -cf - . | xz > centos.tar.xz
