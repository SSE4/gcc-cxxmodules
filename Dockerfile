FROM debian:stretch

LABEL maintainer="SSE4 <tomskside@gmail.com>"

# https://gcc.gnu.org/wiki/InstallingGCC

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y \
    build-essential \
    libgmp-dev \
    libmpfr-dev \
    libmpc-dev \
    libisl-dev \
    file \
    flex \
    subversion && \
    svn co -q svn://gcc.gnu.org/svn/gcc/branches/c++-modules gcc && \
    cd gcc && \
    mkdir objdir && \
    cd objdir && \
    ../configure --prefix=/host/gcc --enable-languages=c,c++ --disable-multilib && \
    make && \
    make install

FROM debian:stretch

COPY --from=0 /host/gcc /host/gcc

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y \
    libisl15 \
    libgmp10 \
    libmpfr4 \
    libmpc3 \
    libc6-dev \
    binutils && \
    ln -s /host/gcc/bin/gcc /usr/bin/gcc && \
    ln -s /host/gcc/bin/g++ /usr/bin/g++
