FROM ubuntu:16.04

RUN dpkg --add-architecture i386 && \
	apt-get update && \
	apt-get install g++-5-multilib -y && \
	apt-get install -y \
			curl \
			dosfstools \
			g++-multilib \
			gawk \
			gcc-multilib \
			git \
			lib32z1-dev \
			libcrypto++-dev:i386 \
			libcrypto++9v5:i386 \
			liblzo2-dev:i386 \
			libstdc++-5-dev:i386 \
			libusb-1.0-0-dev:i386 \
			libusb-1.0-0:i386 \
			python \
			build-essential \
			diffstat \
			texinfo \
			chrpath \
			wget \
			cpio \
			libsdl1.2-dev \
			python3 \
			locales \
			uuid-dev:i386 && \
			rm -rf /var/lib/apt/lists/*

RUN cd /usr/lib; ln -s libcrypto++.so.9.0.0 libcryptopp.so.6

RUN locale-gen en_US.UTF-8
ENV LC_ALL=en_US.UTF-8 \
	LANG=en_US.UTF-8 \
	LANGUAGE=en_US.UTF-8

RUN update-locale

VOLUME ["/opt/oe-core", "/root/.ssh"]
WORKDIR "/opt/oe-core"

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
