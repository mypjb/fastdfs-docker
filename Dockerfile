FROM centos

MAINTAINER mypjb/fastdfs docker maintainer 280417314@qq.com

#fastdfs cofnig git
ENV FASTDFS_CONFIG_GIT=https://github.com/mypjb/fastdfs-docker.git

#fastdfs nginx module git
ENV FASTDFS_NGINX_GIT=https://github.com/happyfish100/fastdfs-nginx-module.git

#fastdfs url
ENV FASTDFS_URL https://github.com/happyfish100/fastdfs/archive/V5.10.tar.gz
# fastdfs lib
ENV FASTDFS_LIBCOMMON https://github.com/happyfish100/libfastcommon/archive/V1.0.35.tar.gz
# fastdfs path
ENV FASTDFS_PATH /usr/local/fastdfs
# fastdfs lib path
ENV FASTDFS_PACKAGE_PATH /usr/local/package/libfastcommon

#nginx install file
ENV NGINX_URL http://nginx.org/download/nginx-1.12.0.tar.gz

#nginx install file  dir
ENV NGINX_PACKAGE_PATH /usr/local/package/nginx

#nginx default install dir
ENV NGINX_PATH /usr/local/nginx

#nginx default depend
ENV NGINX_DEPEND pcre-devel \
		 zlib-devel \
		 gd-devel 

#nginx install confiure
ENV NGINX_CONFIGURE --with-stream \
		    --with-http_image_filter_module \
	            --add-module=/usr/local/nginx/modules/fastdfs/src


RUN  yum update -y \
	&& yum install -y gcc make wget net-tools git


#install fastdfs
RUN echo "begin install fastdfs" \
	&& yum install -y perl-devel \
	&& mkdir -p $FASTDFS_PATH \
	&& mkdir -p $FASTDFS_PACKAGE_PATH \
	&& wget $FASTDFS_LIBCOMMON -O libfastcommon.tar.gz \
	&& tar -xzf libfastcommon.tar.gz -C $FASTDFS_PACKAGE_PATH --strip-components=1 \
	&& rm -rf libfastcommon.tar.gz \
	&& cd $FASTDFS_PACKAGE_PATH \
	&& ./make.sh \
	&& ./make.sh install \
	&& wget $FASTDFS_URL -O	fastdfs.tar.gz \
	&& tar -xzf fastdfs.tar.gz -C $FASTDFS_PATH --strip-components=1 \
	&& rm -rf fastdfs.tar.gz \
	&& cd $FASTDFS_PATH \
	&& ./make.sh \
	&& ./make.sh install \
	&& ln -s $FASTDFS_PATH/tracker/fdfs_trackerd /usr/local/bin \
	&& ln -s $FASTDFS_PATH/storage/fdfs_storaged /usr/local/bin \
	&& echo "end install fastdfs"

#pull config
RUN echo "pull fastdfs config" \
	&& mkdir fastdfs_git \
	&& git clone $FASTDFS_CONFIG_GIT fastdfs_git \
	&& cp fastdfs_git/conf/* $FASTDFS_PATH/conf \
        && mkdir -p $	$NGINX_PATH/moduels/fastdfs \
        && git clone $FASTDFS_NGINX_GIT	$NGINX_PATH/modules/fastdfs \
	&& cp fastdfs_git/fastdfs-nginx-module/* $NGINX_PATH/modules/fastdfs/src \
 	&& rm -rf fastdfs_git


#install nginx
RUN echo "begin nginx" \
	&& yum install -y $NGINX_DEPEND \
	&& wget $NGINX_URL -O nginx.tar.gz \ 
	&& mkdir -p $NGINX_PACKAGE_PATH \
	&& tar -xzvf nginx.tar.gz -C $NGINX_PACKAGE_PATH --strip-components=1 \
	&& rm -rf nginx.tar.gz \
	&& cd $NGINX_PACKAGE_PATH \
	&& ./configure $NGINX_CONFIGURE \
	&& make \
	&& make install \
	&& ln -s $NGINX_PATH/sbin/nginx /usr/local/bin	
	
RUN mkdir -p /storage/fastdfs

EXPOSE 23000 22122 80

ENV TRACKER_ENABLE 0

CMD nginx ; \
	if test $TRACKER_ENABLE -eq 1 ; then fdfs_trackerd $FASTDFS_PATH/conf/tracker.conf ;  fi ; \
	fdfs_storaged $FASTDFS_PATH/conf/storage.conf  ; \
	/bin/bash
