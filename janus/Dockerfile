FROM debian

RUN apt update 
RUN apt -y install \ 
    nano \ 
	build-essential \ 
	curl \ 
	git \ 
	wget \ 
    automake \
    cmake \ 
    doxygen \
    gengetopt \
    graphviz \
    libconfig-dev \
    libcurl4-openssl-dev \
    libglib2.0-dev \
    libjansson-dev \
    liblua5.3-dev \
    libmicrohttpd-dev \
    libogg-dev \
    libopus-dev \
    libsofia-sip-ua-dev \
    libssl-dev \
    libtool \
    ninja-build \ 
    pkg-config \
    python3-pip \
    zlib1g-dev

RUN pip3 install meson
RUN pip3 install ninja

# install libnice
RUN cd /tmp
RUN git clone https://gitlab.freedesktop.org/libnice/libnice
RUN cd libnice && /usr/local/bin/meson --prefix=/usr build && ninja -C build && ninja -C build install

# install libsrtp
RUN cd /tmp
RUN wget https://github.com/cisco/libsrtp/archive/v2.2.0.tar.gz && tar xfv v2.2.0.tar.gz 
RUN cd libsrtp-2.2.0 && \
    ./configure --prefix=/usr --enable-openssl && \
    make shared_library && make install

#  install usrsctp
RUN cd /tmp
RUN git clone https://github.com/sctplab/usrsctp 
RUN cd usrsctp && ./bootstrap && \
    ./configure --prefix=/usr --disable-programs --disable-inet --disable-inet6 && \
    make && make install

# install libwebsockets
RUN cd /tmp
RUN git clone https://libwebsockets.org/repo/libwebsockets
RUN cd libwebsockets && mkdir build && cd build && \
    cmake -DLWS_MAX_SMP=1 -DLWS_WITHOUT_EXTENSIONS=0 -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_C_FLAGS="-fpic" .. && \
    make && make install

# install Eclipse Paho MQTT 
RUN cd /tmp
RUN git clone https://github.com/eclipse/paho.mqtt.c.git
RUN cd paho.mqtt.c && make && make install

# install Nanomsg
# RUN aptitude install -y libnanomsg-dev

RUN cd /tmp; \
	git clone https://github.com/meetecho/janus-gateway.git; \
	cd janus-gateway; \
	sh autogen.sh; \
	./configure --prefix=/opt/janus; \
	make; \
	make install; \
	make configs

RUN sed -i "s/localhost:1883/rabbitmq:1883/g" /opt/janus/etc/janus/janus.transport.mqtt.jcfg

RUN mkdir /opt/janus/lib/janus/loggers

RUN echo 'alias ll="ls -alhF"' >> ~/.bashrc

COPY /cert/domain/domain-selfsigned.crt /etc/ssl/certs/
COPY /cert/domain/domain-selfsigned.key /etc/ssl/private/
COPY /cert/public/public-selfsigned.crt /etc/ssl/certs/
COPY /cert/public/public-selfsigned.key /etc/ssl/private/
COPY /cert/local/local-selfsigned.crt /etc/ssl/certs/
COPY /cert/local/local-selfsigned.key /etc/ssl/private/

COPY janus/etc/janus.transport.websockets.jcfg /opt/janus/etc/janus/janus.transport.websockets.jcfg
COPY janus/etc/janus.jcfg /opt/janus/etc/janus/janus.jcfg

ARG CERT="local"
ENV CERT=${CERT}
RUN sed -i "s/CERT/${CERT}/g" ./opt/janus/etc/janus/janus.transport.websockets.jcfg
RUN sed -i -e "s/#string_ids = true/string_ids = true/g" ./opt/janus/etc/janus/janus.plugin.videoroom.jcfg
RUN sed -i -e "s:admin_http = false:admin_http = true:" /opt/janus/etc/janus/janus.transport.http.jcfg

CMD ["/opt/janus/bin/janus", "-F", "/opt/janus/etc/janus"]
