FROM ubuntu:22.04

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

# Install base dependencies
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        python3 \
        python3-pip \
        python3-venv \
        automake \
        autoconf \
        tmux \
        redis-server \
        wget \
        curl \
        sudo \
        htop \
        cmake \
        clang \
        vim \
        unzip \
        git \
        binutils-arm-none-eabi \
        gcc-arm-none-eabi \
        build-essential \
        pkg-config \
        libglib2.0-dev \
        ninja-build \
        # Development tools
        gdb \
        gdb-multiarch \
        strace \
        ltrace \
        ripgrep \
        fd-find \
        jq \
        less \
        man-db \
        # For Claude Code
        nodejs \
        npm \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages
RUN pip3 install --no-cache-dir \
    virtualenv \
    virtualenvwrapper \
    cython \
    setuptools \
    ipython \
    ipdb

# Set up environment variables
ENV FUZZWARE=/workspaces/fuzzware
ENV WORKON_HOME=/home/vscode/.virtualenvs
ENV VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3

# Create vscode user (standard devcontainer user)
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Create necessary directories
RUN mkdir -p $WORKON_HOME /home/vscode/.cache \
    && chown -R $USERNAME:$USERNAME /home/vscode

USER $USERNAME

# Add bashrc additions for virtualenvwrapper and aliases
COPY --chown=$USERNAME:$USERNAME .devcontainer/bashrc-additions.sh /home/vscode/.bashrc-fuzzware
RUN echo 'source ~/.bashrc-fuzzware' >> /home/vscode/.bashrc

WORKDIR /workspaces/fuzzware
