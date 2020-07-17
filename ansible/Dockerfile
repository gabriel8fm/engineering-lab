FROM alpine:latest
MAINTAINER Gabriel Miranda <gabriel8fm@gmail.com>

ENV PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/ansible/.local/bin:/ansible/.gem/ruby/2.5.0/bin'

RUN apk update && apk upgrade && \
  apk add bash git python3 python3-dev ruby openssh-client openssl vim sshpass \
  py3-paramiko py3-psutil py3-pluggy py3-bcrypt py3-pynacl \
  py3-cryptography py3-cffi py3-docutils py3-rsa py3-click py3-dateutil \
  py3-urllib3 py3-markupapp-name-safe py3-pygit2 py3-future py-futures py3-requests \
  py3-ptyprocess py3-mccabe py3-pyflakes py3-chardet py3-certifi \
  py3-atomicwrites py3-attrs py3-py py-openssl \
  ruby-io-console ruby-json ruby-ffi ruby-concurrent-ruby \
  ruby-multi_json ruby-etc ruby-rspec ruby-rspec-support ruby-rspec-core \
  ruby-rspec-expectations ruby-rspec-mocks ruby-dev ruby-webrick libstdc++ g++ make && \
  gem install etc inspec inspec-bin rubocop -N && \
  pip3 install boto botocore boto3 ansible molecule && \
  apk del ruby-dev libstdc++ g++ make && \
  adduser -h /ansible -s /bin/bash -D ansible

RUN mkdir -p /ansible
ADD . /ansible
WORKDIR /ansible

ENV ANSIBLE_STDOUT_CALLBACK='debug'
