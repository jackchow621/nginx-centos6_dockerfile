# 基于centos6基础镜像
FROM centos:6
MAINTAINER jackchow "jack_chow621@sina.com"

WORKDIR /home

# 安装wget
RUN yum install -y wget && \
    rpm --rebuilddb && \
    yum install -y tar && \
    wget http://nginx.org/download/nginx-1.8.0.tar.gz && \
    tar -zxvf nginx-1.8.0.tar.gz && \
    mv nginx-1.8.0/ nginx && \
    rm -f nginx-1.8.0.tar.gz

WORKDIR nginx

# 编译安装nginx
RUN rpm --rebuilddb && \
    yum install -y gcc make pcre-devel zlib-devel && \
    ./configure --prefix=/usr/local/nginx --with-pcre && \
    make && \
    make install && \
    /usr/local/nginx/sbin/nginx && \
    echo "daemon off;">>/usr/local/nginx/conf/nginx.conf && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    yum clean all

ENV TZ Asia/Shanghai

# 切换到/usr/local/nginx目录，配置文件在/usr/local/nginx/conf/nginx.conf
WORKDIR /usr/local/nginx

EXPOSE 80 443

# 启动nginx执行以下的命令
CMD ["/usr/local/nginx/sbin/nginx"]