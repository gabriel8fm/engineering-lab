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

RUN yum install -y virt-what
RUN yum install -y salt-minion openssh-server

RUN mkdir /var/run/sshd
RUN echo 'root:THEPASSWORDYOUCREATED' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22 4505 4506
CMD ["/usr/sbin/sshd", "-D"]
