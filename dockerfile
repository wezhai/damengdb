#基础镜像
FROM 	centos:centos7

#设置 supervisor
RUN 	mkdir -p /var/log/supervisor
ADD 	supervisord.conf /etc/supervisord.conf

#安装相关软件
RUN	yum install passwd openssl openssh-server iproute python-setuptools -y \
	&& yum clean all && easy_install supervisor

#设置sshd
RUN     ssh-keygen -q -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key -N '' \
        && ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N '' \
        && ssh-keygen -t dsa -f /etc/ssh/ssh_host_ed25519_key  -N '' \
        && sed -i "s/#UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config \
        && sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config \
        && mkdir -p /root/.ssh && chown root.root /root && chmod 700 /root/.ssh \
        && echo 'root:root' | chpasswd

#下载并安装达梦数据库
ENV	VERSION dm7_neoky6_64 
ENV	DOWNLOADURL http://product.dameng.com/zt/download
ADD	install.xml /home
RUN 	yum install -y wget\
	&& wget ${DOWNLOADURL}/${VERSION}.tar.gz -P /home\
	&& yum remove wget -y\
	&& yum clean all \
	&& tar -xvf /home/${VERSION}.tar.gz -C /home\
	&& rm -rf /home/${VERSION}.tar.gz\
	&& cd /home/${VERSION}\
 	&& chmod +x DMInstall.bin\
	&& ./DMInstall.bin -q /home/install.xml\
	&& rm -rf /home/dm7* /home/install.xml

WORKDIR /opt/dmdbms

#开放端口
EXPOSE	5236 22

#运行supervisor
CMD	["/usr/bin/supervisord"]
