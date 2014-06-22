# From-scratch CentOS 6.5 Docker image

As-minimal-as-possible CentOS 6.5 image using `febootstrap`.

Ok, this also contains the [EPEL](http://fedoraproject.org/wiki/EPEL) repo
configs.  But it's still pretty minimal.

Modeled after [docker-brew-ubuntu](https://github.com/tianon/docker-brew-ubuntu).

(Now also builds a CentOS 5 image, but I believe you have to do so *on* CentOS 5.)

## generating filesystem image

    ./build_centos.sh [5|6]
