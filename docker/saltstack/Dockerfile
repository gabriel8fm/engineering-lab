FROM centos:7

RUN rpm --import https://repo.saltstack.com/yum/redhat/7/x86_64/latest/SALTSTACK-GPG-KEY.pub

RUN touch /etc/yum.repos.d/saltstack.repo
RUN echo "[saltstack-repo]" >> /etc/yum.repos.d/saltstack.repo
RUN echo "name=SaltStack repo for RHEL/CentOS \$releasever" >> /etc/yum.repos.d/saltstack.repo
RUN echo "baseurl=https://repo.saltstack.com/yum/redhat/\$releasever/\$basearch/latest" >> /etc/yum.repos.d/saltstack.repo
RUN echo "enabled=1" >> /etc/yum.repos.d/saltstack.repo
RUN echo "gpgcheck=1" >> /etc/yum.repos.d/saltstack.repo
RUN echo "gpgkey=https://repo.saltstack.com/yum/redhat/\$releasever/\$basearch/latest/SALTSTACK-GPG-KEY.pub" >> /etc/yum.repos.d/saltstack.repo

RUN yum clean expire-cache
RUN yum update -y
RUN yum install -y virt-what salt-master salt-ssh salt-cloud supervisor vim openssh-clients

ADD ./supervisor-salt.conf /etc/supervisor.conf
ADD ./pillar /srv/pillar
ADD ./states /srv/salt

EXPOSE 4505 4506

CMD ["/bin/supervisord", "-n", "-c", "/etc/supervisor.conf"]
