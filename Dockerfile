FROM alpine:latest
LABEL maintainer="me@antonivanov.net"
LABEL description="A building environment with Boost C++ Libraries based on Alpine Linux."

ARG boost_version=1.63.0
ARG boost_dir=boost_1_63_0
ENV boost_version ${boost_version}

# Use bzip2-dev package for Boost IOStreams library support of zip and bzip2 formats
# Use openssl package for wget ssl_helper issue
RUN apk add --no-cache linux-headers build-base openssl \
    && wget http://downloads.sourceforge.net/project/boost/boost/${boost_version}/${boost_dir}.tar.bz2 \
    && tar --bzip2 -xf ${boost_dir}.tar.bz2 \
    && cd ${boost_dir} \
    && ./bootstrap.sh \
    && ./b2 --without-python --prefix=/usr -j 4 link=shared runtime-link=shared install \
    && cd .. && rm -rf ${boost_dir} ${boost_dir}.tar.bz2 \
    && sh -c 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/'

CMD sh