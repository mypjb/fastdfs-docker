FROM centos

MAINTAINER mypjb/fastdfs docker maintainer 280417314@qq.com

ENV FASTDFS_URL https://github.com/happyfish100/fastdfs/archive/V5.10.tar.gz
ENV FASTDFS_LIBCOMMON https://github.com/happyfish100/libfastcommon/archive/V1.0.35.tar.gz
ENV FASTDFS_PATH /usr/local/fastdfs
ENV FASTDFS_PACKAGE_PATH /usr/local/package/libfastcommon

RUN yum update -y

RUN yum install -y gcc make wget net-tools \
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
	&& ./make.sh install 


Copy docker-entrypoint.sh /usr/local/bin/

EXPOSE  23000 22122

ENTRYPOINT ["docker-entrypoint.sh"]

#ENTRYPOINT /usr/local/fastdfs/storage/fdfs_storaged /usr/local/fastdfs/conf/storage.conf


#CMD top -c

STOPSIGNAL SIGQUIT
