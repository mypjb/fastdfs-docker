#!/bin/sh
FASTDFS_PATH=/usr/local/fastdfs

#$FASTDFS_PATH/tracker/fdfs_trackerd $FASTDFS_PATH/conf/tracker.conf

$FASTDFS_PATH/storage/fdfs_storaged $FASTDFS_PATH/conf/storage.conf

top -d 30 -c -b
