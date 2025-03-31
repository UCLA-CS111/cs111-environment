FROM ubuntu:22.04

# Set timezone (important for some packages) 
ARG TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ENV HOME=/home/cs111-student

RUN yes | unminimize

# Install packages (break this up into checkpoints if you're having build issues)
# Apt caching from: https://stackoverflow.com/a/72851168
# TODO: could probably remove some of these packages
RUN --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
  --mount=target=/var/cache/apt,type=cache,sharing=locked \
  rm -f /etc/apt/apt.conf.d/docker-clean \
  &&  apt-get update \
  && apt-get install -y \
  binutils \
  cgdb \
  clang \
  clang-format \
  cmake \
  curl \
  exuberant-ctags \
  g++ \
  gcc \
  gdb \
  gdb-multiarch \
  git \
  libxrandr-dev \
  libncurses5-dev \
  qemu \
  qemu-system-i386 \
  silversearcher-ag \
  tmux \
  vim \
  valgrind \
  autoconf \
  wget \
  python3 \
  python3-pip \
  python-is-python3 \
  libjson-c-dev \
  libfuse-dev \
  sudo \
  fzf \
  openssh-server \
  man \
  file \
  gcc-i686-linux-gnu \
  qemu-user \
  rsync \
  libglib2.0-dev \
  rpcbind \
  manpages-posix-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home --home-dir /home/cs111-student --user-group cs111-student && echo cs111-student:cs111-student | chpasswd \
  && chsh -s /bin/bash cs111-student && echo "cs111-student ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

WORKDIR /home/cs111-student
COPY ./initial_home/. ./

RUN git config --global init.defaultBranch main

COPY ./install/. /install
WORKDIR /install
RUN ./install_bochs.sh

WORKDIR /
COPY entrypoint.sh .
# COPY ./bin/. ./bin

RUN find /home/cs111-student/. -not -type d -not -path "./code/*" -not -name ".version" -print0 | LC_ALL=C sort -z | xargs -0 sha256sum | sha256sum > /home/cs111-student/.version

RUN chown -R cs111-student:cs111-student /home/cs111-student

RUN mv /home/cs111-student /cs111-student

USER cs111-student

ENTRYPOINT [ "/entrypoint.sh" ]
