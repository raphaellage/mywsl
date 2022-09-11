FROM archlinux:base as nesx

ARG USER=rapll
ARG HOST_HOSTNAME=nesx
ARG USER_PASSWORD

RUN pacman -Syy && pacman -S sudo --noconfirm

RUN echo "%wheel ALL=(ALL) ALL" > /etc/sudoers.d/wheel
#RUN useradd -m -d /home/${USER} -g root -G wheel -s /bin/bash ${USER} -u 1000 -p "$(openssl passwd -1 ${USER_PASSWORD})"
RUN useradd ${USER} && usermod -L ${USER}
RUN echo "${USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER ${USER}

WORKDIR /home/${USER}

RUN sudo pacman-key --init
RUN sudo pacman-key --populate
RUN sudo pacman -Syu --noconfirm
RUN sudo pacman -S archlinux-keyring --needed git go base-devel libxcrypt-compat --noconfirm
RUN mkdir ~/yay && cd ~/yay && git clone https://aur.archlinux.org/yay.git .
RUN cd ~/yay && makepkg -si --noconfirm && yay -S zsh --noconfirm

COPY .bashrc /home/${USER}/.bashrc
COPY .zshrc /home/${USER}/.zshrc

RUN git clone https://github.com/Homebrew/brew ~/.linuxbrew/homebrew \
    && eval "$(~/.linuxbrew/homebrew/bin/brew shellenv)" \
    && brew update --force --quiet \
    && chmod -R go-w "$(brew --prefix)/share/zsh"

RUN brew install jandedobbeleer/oh-my-posh/oh-my-posh

CMD ["bash"]


#docker build --build-arg USER_PASSWORD=1337 -t arch .
#docker run -h nesx -it arch