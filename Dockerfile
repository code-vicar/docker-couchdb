FROM debian:jessie

MAINTAINER Scott Vickers <scott.w.vickers@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update \
&& apt-get install --quiet --assume-yes --no-install-recommends \
build-essential \
libtool \
autoconf \
automake \
autoconf-archive \
pkg-config \
libssl-dev \
zlib1g \
zlib1g-dev \
libcurl4-openssl-dev \
lsb-base  \
ncurses-dev \
libncurses-dev \
libmozjs185-1.0 \
libmozjs185-dev \
libicu-dev \
xsltproc \
wget

# install erlang/OTP R16B03-1 from source
RUN mkdir -p /tmp/erlang-source \
&& cd /tmp/erlang-source \
&& export LANG=C \
&& wget http://www.erlang.org/download/otp_src_R16B03-1.tar.gz \
&& tar xzf otp_src_R16B03-1.tar.gz \
&& cd otp_src_R16B03-1 \
&& export ERL_TOP=`pwd` \
&& echo "skipping gs" > lib/gs/SKIP \
&& echo "skipping jinterface" > lib/jinterface/SKIP \
&& echo "skipping odbc" > lib/odbc/SKIP \
&& echo "skipping wx" > lib/wx/SKIP \
&& ./configure --prefix=/usr/local \
&& make && make install

# install couchdb 1.6.1 from source
RUN mkdir -p /tmp/couchdb-source \
&& cd /tmp/couchdb-source \
&& wget http://mirrors.advancedhosters.com/apache/couchdb/source/1.6.1/apache-couchdb-1.6.1.tar.gz \
&& tar xzf apache-couchdb-*.tar.gz \
&& cd apache-couchdb-* \
&& ./configure --prefix=/usr/local --with-js-lib=/usr/lib --with-js-include=/usr/include/mozjs --enable-init \
&& make && make install

# Add couchdb user account
RUN mkdir -p /usr/local/var/lib/couchdb \
&& mkdir -p /usr/local/var/log/couchdb \
&& mkdir -p /usr/local/var/run/couchdb \
&& mkdir -p /usr/local/etc/couchdb/default.d \
&& mkdir -p /usr/local/etc/couchdb/local.d \
&& useradd -d /usr/local/var/lib/couchdb couchdb \
&& chown -R couchdb:couchdb \
/usr/local/lib/couchdb \
/usr/local/etc/couchdb \
/usr/local/var/lib/couchdb \
/usr/local/var/log/couchdb \
/usr/local/var/run/couchdb \
&& chmod -R g+rw \
/usr/local/lib/couchdb \
/usr/local/etc/couchdb \
/usr/local/var/lib/couchdb \
/usr/local/var/log/couchdb \
/usr/local/var/run/couchdb

# clean up apt-get and temp folder
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# start couchdb
USER couchdb
RUN /usr/local/etc/init.d/couchdb start

EXPOSE 5984

CMD ["/bin/sh"]
