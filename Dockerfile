FROM ubuntu:20.04

# Shift timezon to Asia/Tokyo.
RUN apt-get update && \
    apt-get install -y tzdata && \
    apt-get clean && \
    rm -rf /var/lib/apt/list/*
ENV TZ Asia/Tokyo

# Set local to jp.
RUN apt-get update && \
    apt-get install -y language-pack-en && \
    update-locale LANG=en_US.UTF-8 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# from Yocto Project Quick Build
# https://docs.yoctoproject.org/4.0.7/brief-yoctoprojectqs/index.html
RUN apt-get update && apt-get install -y \
    sudo \
    vim \
    gawk \
    wget \
    git \
    diffstat \
    unzip \
    texinfo \
    gcc \
    build-essential \
    chrpath \
    socat \
    cpio \
    python3 \
    python3-pip \
    python3-pexpect \
    xz-utils \
    debianutils \
    iputils-ping \
    python3-git \
    python3-jinja2 \
    libegl1-mesa \
    libsdl1.2-dev \
    pylint3 \
    xterm \
    python3-subunit \
    mesa-common-dev \
    zstd \
    liblz4-tool \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ARG USERNAME=yocto
ARG GROUPNAME=yocto
ARG PASSWORD=yocto
RUN useradd -m -s /bin/bash -G sudo $USERNAME && \
    echo $USERNAME:$PASSWORD | chpasswd && \
    echo "$USERNAME   ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER $USERNAME
WORKDIR /home/$USERNAME/

COPY setup.sh /home/$USERNAME/
COPY build.sh /home/$USERNAME/
RUN mkdir work
RUN sudo chown -R $USERNAME:$USERNAME .

# Yocto-for-RaspberryPi | MIT License | https://github.com/OOKI-KAWAI/Yocto-for-RaspberryPi/blob/main/LICENSE