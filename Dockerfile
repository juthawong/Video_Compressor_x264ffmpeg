FROM centos:centos7
MAINTAINER mehanig <mehanig@gmail.com>

RUN yum install -y http://dl.iuscommunity.org/pub/ius/stable/CentOS/7/x86_64/ius-release-1.0-14.ius.centos7.noarch.rpm \
 && yum install -y python34u \
 && yum install -y git \
 && yum install -y tar \
 && yum install -y gcc \
 && yum install -y pcre-devel \
 && yum install -y zlib-devel \
 && yum install -y openssl \
 && yum install -y openssl-devel \
 && yum -y groupinstall "Development Tools" \
 && yum clean all

RUN git clone -b 2.2 https://github.com/vkholodkov/nginx-upload-module
RUN curl -o nginx.tar.gz  http://nginx.org/download/nginx-1.9.1.tar.gz
RUN tar xvzf nginx.tar.gz
RUN cd nginx-1.9.1 \
  && ./configure --add-module=../nginx-upload-module \
  && make \
  && make install

RUN git clone https://github.com/mehanig/Video_Compressor_x264ffmpeg
RUN cd Video_Compressor_x264ffmpeg \
  && pip3 install -r requirements.txt

RUN mkdir nginx_folder \
    && cd nginx_folder \
    && mkdir upload \
    && cd upload \
    && mkdir tmp

RUN ./usr/local/nginx/sbin/nginx -c /Video_Compressor_x264ffmpeg/nginx_conf/nginx.conf
RUN python3 Video_Compressor_x264ffmpeg/big_upl.py
