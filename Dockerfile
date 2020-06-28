FROM centos:7.3.1611
WORKDIR /app

ADD data .

#RUN curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo \
#    && sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo
RUN yum makecache && yum groupinstall -y "Development tools"
RUN yum install -y git python bzip2 tar pkgconfig atk-devel alsa-lib-devel \
    bison binutils brlapi-devel bluez-libs-devel bzip2-devel cairo-devel \
    cups-devel dbus-devel dbus-glib-devel expat-devel fontconfig-devel \
    freetype-devel gcc-c++ glib2-devel glibc glibc.i686 gperf glib2-devel \
    gtk3-devel java-1.*.0-openjdk-devel libatomic libcap-devel libffi-devel \
    libgcc.i686 libgnome-keyring-devel libjpeg-devel libstdc++ libstdc++.i686 libX11-devel \
    libXScrnSaver-devel libXtst-devel libxkbcommon-x11-devel ncurses-compat-libs \
    nspr-devel nss-devel pam-devel pango-devel pciutils-devel \
    pulseaudio-libs-devel zlib httpd mod_ssl php php-cli python-psutil wdiff \
    xorg-x11-server-Xvfb net-tools wget screen which

RUN tar zxf glibc-2.18.tar.gz && cd glibc-2.18/ && mkdir build && cd build/ && ../configure --prefix=/usr && make -j && make install

#ENV proxy="http://192.168.0.2:1081"
#ENV http_proxy=$proxy
#ENV https_proxy=$proxy
#ENV ftp_proxy=$proxy
#ENV no_proxy="localhost, 127.0.0.1, ::1"

WORKDIR /root/

RUN git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git && mkdir chromium
ENV PATH="$PATH:/root/depot_tools"

WORKDIR chromium

ENTRYPOINT ["/bin/bash"]

RUN fetch --nohooks --no-history chromium
RUN cd src
RUN gclient runhooks
# RUN gn gen out/Default --args='use_sysroot=false symbol_level=0 blink_symbol_level=0 is_debug=false is_clang=false'
# RUN autoninja -C out/Default chrome
