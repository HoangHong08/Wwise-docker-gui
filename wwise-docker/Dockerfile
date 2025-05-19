FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

# Không thêm kiến trúc i386 vì Codespace không hỗ trợ
RUN apt-get update && apt-get install -y \
    wine64 xvfb x11vnc fluxbox novnc websockify pulseaudio pulseaudio-utils \
    supervisor wget curl unzip python3-numpy fonts-wine firefox-esr \
    software-properties-common sudo cabextract net-tools ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks -O /usr/local/bin/winetricks && chmod +x /usr/local/bin/winetricks

RUN useradd --create-home --shell /bin/bash docker && \
    usermod -aG sudo docker && echo "docker ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER docker
WORKDIR /home/docker
ENV WINEARCH=win64
ENV WINEPREFIX=/home/docker/.wine64
ENV DISPLAY=:0

RUN winecfg -v win10 && wineboot --init || true
RUN winetricks -q corefonts dotnet48 vcrun2015 directx9 || true

USER root
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
EXPOSE 8080 5901
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
