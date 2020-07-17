{%- if grains['os_family'] == 'RedHat' %}
nginx-stable:
  pkgrepo.managed:
    - humanname: nginx stable repo
    - baseurl: http://nginx.org/packages/centos/$releasever/$basearch/
    - gpgcheck: 1
    - enabled: 1
    - gpgkey: https://nginx.org/keys/nginx_signing.key

nginx-mainline:
  pkgrepo.managed:
    - humanname: nginx mainline repo
    - baseurl: http://nginx.org/packages/mainline/centos/$releasever/$basearch/
    - gpgcheck: 1
    - enabled: 0
    - gpgkey: https://nginx.org/keys/nginx_signing.key

{%- elif grains['os_family'] == 'Debian' %}
nginx-repo:
  pkgrepo.managed:
    - name: deb http://nginx.org/packages/debian/ {{ grains['oscodename'] }} nginx 
    - key_url: http://nginx.org/keys/nginx_signing.key
    - file: /etc/apt/sources.list.d/nginx.list
{% endif -%}

