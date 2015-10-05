FROM debian:jessie

MAINTAINER Scott Vickers <scott.w.vickers@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

##
# Run-time minimal packages:
#   libcurl-openssl libicu libmozjs185 erlang

# Install erlang/OTP R16B03-1 from source
# Install couchdb 1.6.1 from source
# Install gosu 1.5
RUN apt-get -y update \
&& apt-get install --quiet --assume-yes --no-install-recommends \
build-essential \
libtool \
autoconf \
automake \
autoconf-archive \
pkg-config \
libssl-dev \
libcurl4-openssl-dev \
ncurses-dev \
libncurses-dev \
libmozjs185-1.0 \
libmozjs185-dev \
libicu-dev \
xsltproc \
wget \
&& mkdir -p /tmp_src/erlang-source \
&& cd /tmp_src/erlang-source \
&& wget http://www.erlang.org/download/otp_src_R16B03-1.tar.gz \
&& tar xzf otp_src_R16B03-1.tar.gz \
&& cd otp_src_R16B03-1 \
&& export ERL_TOP=`pwd` \
&& echo "skipping gs" > lib/gs/SKIP \
&& echo "skipping jinterface" > lib/jinterface/SKIP \
&& echo "skipping odbc" > lib/odbc/SKIP \
&& echo "skipping wx" > lib/wx/SKIP \
&& ./configure --prefix=/usr/local \
&& make && make install \
&& mkdir -p /tmp_src/couchdb-source \
&& cd /tmp_src/couchdb-source \
&& wget http://mirrors.advancedhosters.com/apache/couchdb/source/1.6.1/apache-couchdb-1.6.1.tar.gz \
&& tar xzf apache-couchdb-*.tar.gz \
&& cd apache-couchdb-* \
&& ./configure --prefix=/usr/local --with-js-lib=/usr/lib --with-js-include=/usr/include/mozjs --enable-init \
&& make && make install \
&& rm -rf /tmp_src \
&& wget -O /gosu -nv "https://github.com/tianon/gosu/releases/download/1.5/gosu-$(dpkg --print-architecture)" \
&& chmod +x /gosu \
&& apt-get purge -y --auto-remove \
build-essential \
libtool \
autoconf \
automake \
autoconf-archive \
pkg-config \
libssl-dev \
ncurses-dev \
libncurses-dev \
xsltproc \
wget \
&& apt-get clean

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

# configure erlang
ENV ERL_LIBS /usr/local/lib/erlang

# persist couchdb database folder as volume
VOLUME /usr/local/var/lib/couchdb

COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 5984
CMD ["couchdb"]
