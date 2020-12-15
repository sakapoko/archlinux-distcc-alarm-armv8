FROM archlinux

RUN pacman -Syu --noconfirm && pacman -S base-devel git distcc --noconfirm

# non-root user for builds
RUN useradd -m -G wheel -s /bin/bash build
RUN sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
USER build
WORKDIR /home/build
RUN git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm
RUN yay -S aur/distccd-alarm-armv8 --noconfirm

USER root
RUN sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen && \
	sed -i 's/^# *\(en_US ISO-8859-1\)/\1/' /etc/locale.gen && \
	locale-gen && \
	echo LANG=en_US.UTF-8 > /etc/locale.conf

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 3632
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
