FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV TERM=xterm-256color
ENV COLORTERM=truecolor

# ================================================================
# Packages
# ================================================================

RUN apt-get update && apt-get install -y \
    sudo \
    zsh \
    git \
    curl \
    wget \
    ca-certificates \
    vim \
    nano \
    tmux \
    less \
    file \
    tree \
    unzip \
    zip \
    xxd \
    ripgrep \
    fd-find \
    jq \
    man-db \
    procps \
    iproute2 \
    iputils-ping \
    net-tools \
    dnsutils \
    openssh-client \
    gcc \
    g++ \
    make \
    cmake \
    clang \
    llvm \
    lld \
    nasm \
    gdb \
    binutils \
    elfutils \
    libc6-dbg \
    libc6-dev \
    python3 \
    python3-dev \
    python3-pip \
    python3-venv \
    libssl-dev \
    libffi-dev \
    pkg-config \
    strace \
    ltrace \
    patchelf \
    checksec \
    radare2 \
    qemu-user \
    qemu-user-static \
    gosu \
    && rm -rf /var/lib/apt/lists/*

# ================================================================
# Create pwn user
# ================================================================

RUN useradd \
    --create-home \
    --shell /bin/zsh \
    pwn

# Passwordless sudo
RUN echo "pwn ALL=(ALL) NOPASSWD:ALL" \
    > /etc/sudoers.d/pwn && \
    chmod 0440 /etc/sudoers.d/pwn

# ================================================================
# Pwn user environment
# ================================================================

USER pwn
WORKDIR /home/pwn

# ================================================================
# Python virtual environment
# ================================================================

RUN python3 -m venv "$HOME/venv"

ENV PATH="/home/pwn/venv/bin:/home/pwn/.local/bin:${PATH}"

RUN pip install --no-cache-dir \
    pwntools \
    ropper \
    ROPgadget

# ================================================================
# Pwndbg
# ================================================================

RUN git clone --depth=1 \
    https://github.com/pwndbg/pwndbg.git \
    "$HOME/pwndbg"

RUN curl -LsSf https://astral.sh/uv/install.sh | sh

ENV PATH="/home/pwn/.local/bin:/home/pwn/venv/bin:${PATH}"

RUN cd "$HOME/pwndbg" && \
    ./setup.sh

# ================================================================
# User configuration
# ================================================================

COPY --chown=pwn:pwn zshrc /home/pwn/.zshrc

# ================================================================
# Workspace
# ================================================================

USER root

RUN mkdir -p /workspace

WORKDIR /workspace

# ================================================================
# Portable UID/GID entrypoint
# ================================================================

COPY entrypoint.sh /usr/local/bin/pwnlab-entrypoint

RUN chmod 755 /usr/local/bin/pwnlab-entrypoint

USER root

ENTRYPOINT ["/usr/local/bin/pwnlab-entrypoint"]