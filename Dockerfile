FROM resin/rpi-raspbian:stretch
RUN groupadd -g 1000 pi && \
    useradd  -g      pi -G sudo -m -s /bin/bash pi && \
    usermod -aG adm,dialout,cdrom,sudo,audio,video,plugdev,games,users,input pi && \
    echo 'pi:raspberry' | chpasswd && \
    echo 'pi ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
#RUN echo 'Acquire::http::Proxy "http://apt-cache-server:3142";' | tee /etc/apt/apt.conf.d/02proxy
RUN echo "US/Pacific" > /etc/timezone
ADD ./scripts /home/pi/jns 
WORKDIR   "/home/pi/jns"

RUN apt update && \
    apt -y install build-essential git pandoc \
        libxml2-dev libxslt-dev \
        libatlas-base-dev \
        zlib1g-dev libfreetype6-dev liblcms2-dev \
        libwebp-dev tcl8.5-dev tk8.5-dev \
        libharfbuzz-dev libfribidi-dev \
        libhdf5-dev libnetcdf-dev \
        python3-pip python3-dev python3-venv \
        libzmq3-dev sqlite3

RUN sudo -u pi ./inst_stack.sh
RUN sudo -u pi ./conf_jupyter.sh

#
USER pi
WORKDIR   "/home/pi/notebooks"
VOLUME    "/home/pi/notebooks"
EXPOSE 8888
CMD ["bash", "-c", ". /home/pi/.venv/jns/bin/activate && jupyter lab"]
#CMD ["bash", "-c", ". /home/pi/.venv/jns/bin/activate && jupyter notebook"]

