# fastdfs-docker
this is a fastdfs docker project


start storage:
docker run --add-host fastdfs.net:10.10.5.170 --name fastdfs --net=host -v storage:/storage/fastdfs -it mypjb/fastdfs
start

simultaneously started:
docker run --add-host fastdfs.net:10.10.5.170 --name fastdfs --net=host -e TRACKER_ENABLE=1 -v storage:/storage/fastdfs -it mypjb/fastdfs
start

if you want to define listen nginx port Atendofstream NGINX_PORT replace:
docker run --add-host fastdfs.net:10.10.5.170 --name fastdfs --net=host -e TRACKER_ENABLE=1 -e NGINX_PORT=81 -v storage:/storage/fastdfs -it mypjb/fastdfs
start
