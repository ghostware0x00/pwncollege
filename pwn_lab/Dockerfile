# ================================================================
# PwnLab
# Isolated Linux environment for pwn.college / CTF / RE practice
# ================================================================

FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# ------------------------------------------------
# Locale / terminal
# ------------------------------------------------

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV TERM=xterm-256color
ENV COLORTERM=truecolor

# ------------------------------------------------
# Base system + development tools
# ------------------------------------------------

RUN apt-get update && apt-get install -y \
    zsh \
    git \
    curl \
    wget \
    ca-certificates \
    sudo \
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
    \
    gcc \
    g++ \
    make \
    cmake \
    clang \
    llvm \
    lld \
    nasm \
    \
    gdb \
    binutils \
    elfutils \
    libc6-dbg \
    libc6-dev \
    \
    python3 \
    python3-dev \
    python3-pip \
    python3-venv \
    libssl-dev \
    libffi-dev \
    pkg-config \
    \
    strace \
    ltrace \
    patchelf \
    checksec \
    \
    radare2 \
    \
    qemu-user \
    qemu-user-static \
    \
    && rm -rf /var/lib/apt/lists/*

# ------------------------------------------------
# Create non-root pwn user
# ------------------------------------------------

RUN useradd \
    --create-home \
    --shell /bin/zsh \
    pwn

RUN echo "pwn ALL=(ALL) NOPASSWD:ALL" \
    > /etc/sudoers.d/pwn

RUN chmod 0440 /etc/sudoers.d/pwn

# ------------------------------------------------
# Switch to pwn user
# ------------------------------------------------

USER pwn

WORKDIR /workspace

# ------------------------------------------------
# Oh My Zsh
# ------------------------------------------------

RUN git clone \
    --depth=1 \
    https://github.com/ohmyzsh/ohmyzsh.git \
    "$HOME/.oh-my-zsh"

# ------------------------------------------------
# Powerlevel10k
# ------------------------------------------------

RUN git clone \
    --depth=1 \
    https://github.com/romkatv/powerlevel10k.git \
    "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"

# ------------------------------------------------
# Zsh plugins
# ------------------------------------------------

RUN git clone \
    --depth=1 \
    https://github.com/zsh-users/zsh-autosuggestions.git \
    "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"

RUN git clone \
    --depth=1 \
    https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"

# ------------------------------------------------
# Python virtual environment
# ------------------------------------------------

RUN python3 -m venv "$HOME/venv"

ENV PATH="/home/pwn/venv/bin:/home/pwn/.local/bin:${PATH}"

# ------------------------------------------------
# Python pwn tools
# ------------------------------------------------

RUN pip install --no-cache-dir \
    pwntools \
    ropper \
    ROPgadget

# ------------------------------------------------
# Pwndbg
# ------------------------------------------------

RUN git clone \
    --depth=1 \
    https://github.com/pwndbg/pwndbg.git \
    "$HOME/pwndbg"

RUN cd "$HOME/pwndbg" && \
    ./setup.sh

# ------------------------------------------------
# User configuration
# ------------------------------------------------

COPY --chown=pwn:pwn p10k.zsh /home/pwn/.p10k.zsh
COPY --chown=pwn:pwn zshrc /home/pwn/.zshrc

# ------------------------------------------------
# Shell defaults
# ------------------------------------------------

ENV SHELL=/bin/zsh

# ------------------------------------------------
# Working directory
# ------------------------------------------------

WORKDIR /workspace

# ------------------------------------------------
# Container startup
# ------------------------------------------------

CMD ["zsh", "-l"]
