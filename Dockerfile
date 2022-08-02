#
# TinyMediaManager Dockerfile
#
FROM jlesage/baseimage-gui:debian-11

# Define software versions.
ARG TMM_VERSION=4.3.1
ARG LIBMEDIAINFO_VERSION=22.06
ARG LIBZEN0_VERSION=0.4.39

# Define software download URLs.
ARG TMM_URL=https://release.tinymediamanager.org/v4/dist/tmm_${TMM_VERSION}_linux-amd64.tar.gz
ARG LIBMEDIAINFO_URL=https://mediaarea.net/download/binary/libmediainfo0/${LIBMEDIAINFO_VERSION}/libmediainfo0v5_${LIBMEDIAINFO_VERSION}-1_amd64.Debian_11.deb
ARG LIBZEN0_URL=https://mediaarea.net/download/binary/libzen0/${LIBZEN0_VERSION}/libzen0v5_${LIBZEN0_VERSION}-1_amd64.Debian_11.deb
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/jre/bin
# Define working directory.
WORKDIR /tmp

# Add Repository for SID Packages
#RUN echo 'deb http://deb.debian.org/debian sid main' >> /etc/apt/sources.list
# Install dependencies.
RUN \
    apt update && \
    apt install -y  \
    apt-utils \
    #ffmpeg \
    locales \
    #libmediainfo0v5 \
    fonts-dejavu \
    zenity \
    dpkg \
    #npm \
    #libavcodec59 \
    #libavdevice59 \
    #libavfilter8 \
    #libavformat59 \
    #libavutil57 \
    #libpostproc56 \
    #libswresample4 \
    #libmms0 \
    #libtinyxml2-9 \
    #libzen0v5 \
    wget 
    
# Change locale
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
RUN sed -i '/^#.* en_US.UTF-8 /s/^#//' /etc/locale.gen
RUN locale-gen en_US.UTF-8

# Download TinyMediaManager
RUN \
    mkdir -p /defaults && \
    wget ${TMM_URL} -O /defaults/tmm.tar.gz
    
# Download LibMediaInfo   
RUN \
    mkdir -p /temp && \
    wget ${LIBZEN0_URL} -O /temp/libzen0v5_${LIBZEN0_VERSION}-1_amd64.Debian_11.deb \
         ${LIBMEDIAINFO_URL} -O /temp/libmediainfo0v5_${LIBMEDIAINFO_VERSION}-1_amd64.Debian_11.deb
RUN \
    dpkg -i /temp/libzen0v5_${LIBZEN0_VERSION}-1_amd64.Debian_11.deb && \
            /temp/libmediainfo0v5_${LIBMEDIAINFO_VERSION}-1_amd64.Debian_11.deb
# Cleanup
#RUN \
    #rm -r /temp
    
          
    

# Maximize only the main/initial window.
# It seems this is not needed for TMM 3.X version.
#RUN \
#    sed-patch 's/<application type="normal">/<application type="normal" title="tinyMediaManager \/ 3.0.2">/' \
#        /etc/xdg/openbox/rc.xml

# Generate and install favicons.
RUN \
    APP_ICON_URL=https://gitlab.com/tinyMediaManager/tinyMediaManager/raw/45f9c702615a55725a508523b0524166b188ff75/AppBundler/tmm.png && \
    install_app_icon.sh "$APP_ICON_URL"
    
# Cleanup
RUN \
    apt upgrade && \
    apt autoremove -y

# Add files.
COPY rootfs/ /
COPY VERSION /

# Set environment variables.
ENV APP_NAME="TinyMediaManager" \
    S6_KILL_GRACETIME=8000

# Define mountable directories.
VOLUME ["/config"]
VOLUME ["/media"]

# Metadata.
LABEL \
      org.label-schema.name="tinymediamanager" \
      org.label-schema.description="Docker container for TinyMediaManager" \
      org.label-schema.version="unknown" \
      #org.label-schema.vcs-url="https://github.com/romancin/tmm-docker" \
      org.label-schema.schema-version="1.0"
