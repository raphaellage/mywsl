FROM archlinux:base as nesx

ARG USER=rapll
ARG HOST_HOSTNAME=nesx
ARG USER_PASSWORD

# pacman
RUN pacman -Syy && pacman -S sudo --noconfirm

# increase pacman install speed
RUN echo "ParallelDownloads = 5" >> /etc/pacman.conf

# user setting
RUN echo "%wheel ALL=(ALL) ALL" > /etc/sudoers.d/wheel
RUN useradd ${USER} && usermod -L ${USER}
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

# homebrew needed packages
RUN git clone https://github.com/Homebrew/brew ~/.homebrew \
    && eval "$(~/.homebrew/bin/brew shellenv)" \
    && brew update --force --quiet \
    && chmod -R go-w "$(brew --prefix)/share/zsh" \
    && brew install jandedobbeleer/oh-my-posh/oh-my-posh

# yay
RUN mkdir /home/${USER}/.yay && cd /home/${USER}/.yay && git clone https://aur.archlinux.org/yay.git . && makepkg -si --noconfirm

# yay needed packages
RUN yay -S zsh nerd-fonts-fira-code lua --noconfirm \
    && git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions \
    && git clone https://github.com/marlonrichert/zsh-autocomplete.git ~/.zsh/zsh-autocomplete

# lunarvim
RUN bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh) -y --no-install-dependencies || true

COPY oh-my-wsl.omp.json /home/${USER}/.oh-my-wsl.omp.json
COPY .bashrc /home/${USER}/.bashrc
COPY .zshrc /home/${USER}/.zshrc

# Rust stuff
RUN source /home/${USER}/.cargo/env && cargo install bat exa procs du-dust ytop tealdeer grex fd-find git-delta zoxide

CMD ["bash"]


#docker build --build-arg USER_PASSWORD=1337 -t arch .
#docker run -h nesx -e TZ=America/Sao_Paulo -it arch