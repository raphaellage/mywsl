FROM archlinux:base as mywsl

ARG USER
ARG USER_PASSWORD

# pacman
RUN pacman -Syy && pacman -S sudo --noconfirm

# increase pacman install speed
RUN echo "ParallelDownloads = 5" >> /etc/pacman.conf

# user setting
RUN echo "%wheel ALL=(ALL) ALL" > /etc/sudoers.d/wheel
RUN useradd -m -d /home/${USER} -g root -G wheel -s /bin/bash ${USER} -u 1000 -p "$(openssl passwd -1 ${USER_PASSWORD})"
RUN echo "${USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER ${USER}

WORKDIR /home/${USER}

# pacman setup
RUN sudo pacman-key --init
RUN sudo pacman-key --populate
RUN sudo pacman -Syu --noconfirm

# pacman needed packages
RUN sudo pacman -S archlinux-keyring --needed git base-devel make python python-pip yarn npm go neovim libxcrypt-compat --noconfirm \
    && curl https://sh.rustup.rs -sSf | sh -s -- -y

# homebrew
RUN git clone https://github.com/Homebrew/brew ~/.homebrew \
    && eval "$(~/.homebrew/bin/brew shellenv)" \
    && brew update --force --quiet \
    && chmod -R go-w "$(brew --prefix)/share/zsh"

# yay
RUN mkdir /home/${USER}/.yay && cd /home/${USER}/.yay && git clone https://aur.archlinux.org/yay.git . && makepkg -si --noconfirm

# yay needed packages
RUN yay -S zsh nerd-fonts-fira-code lua --noconfirm \
    && git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

# lunarvim
RUN bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh) -y --no-install-dependencies || true

# Rust stuff
RUN source /home/${USER}/.cargo/env && cargo install bat exa procs ytop tealdeer grex fd-find git-delta zoxide

RUN sudo pacman -S wget gcc --noconfirm

RUN wget https://github.com/Kitware/CMake/releases/download/v3.18.2/cmake-3.18.2-Linux-x86_64.sh -O .cmake.sh \
    && sudo sh .cmake.sh --prefix=/usr/local/ --exclude-subdir

RUN source /home/${USER}/.cargo/env && cargo install starship

RUN mkdir .config/starship && git clone https://gist.github.com/2849cef0a9601df6e709288d6d4e5819.git .config/starship
COPY .bashrc /home/${USER}/.bashrc
COPY .zshrc /home/${USER}/.zshrc
RUN sudo echo -e "[USER]\ndefault=${user}" | sudo tee -a /etc/wsl.conf
RUN sudo groupadd docker && sudo usermod -aG docker ${USER}

CMD ["zsh"]