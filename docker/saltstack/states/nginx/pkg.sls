# nginx.pkg
#
# Manages the nginx pkg installation.

{% from 'nginx/map.jinja' import nginx with context %}
{% if nginx.install_from_phusionpassenger %}
  {% set from_official = false %}
  {% set from_ppa = false %}
  {% set from_phusionpassenger = true %}
{% else %}
  {% set from_official = false %}
  {% set from_ppa = false %}
  {% set from_phusionpassenger = false %}
{%- endif %}

# {{ nginx}}

{% if salt['grains.get']('osrelease') in ['16.04'] %}
nginx_install:
  pkg.installed:
    - name: {{ nginx.package }}
{% endif %}

{% if salt['grains.get']('os_family') == 'RedHat' %}
nginx_install:
  pkg.installed:
    - name: {{ nginx.package }}
{% endif %}

{% if salt['grains.get']('os_family') == 'Debian' %}
nginx-official-repo:
  pkgrepo:
    {%- if nginx.install_from_repo %}
    - managed
    {%- else %}
    - absent
    {%- endif %}
    - humanname: nginx apt repo
    - name: deb [ arch=amd64 ] http://nginx.org/packages/{{ grains['os'].lower() }}/ {{ grains['oscodename'] }} nginx
    - file: /etc/apt/sources.list.d/nginx-official-{{ grains['oscodename'] }}.list
    - keyid: ABF5BD827BD9BF62
    - keyserver: keyserver.ubuntu.com
    {% if salt['grains.get']('osrelease') in ['16.04'] %}
    - require_in:
      - pkg: nginx_install
    - watch_in:
      - pkg: nginx_install
    {% endif %}
nginx_ppa_repo:
  pkgrepo:
    {%- if nginx.install_from_ppa %}
    - managed
    {%- else %}
    - absent
    {%- endif %}
    {% if salt['grains.get']('os') == 'Ubuntu' %}
    - ppa: nginx/{{ nginx.ppa_version }}
    {% else %}
    - name: deb http://ppa.launchpad.net/nginx/{{ nginx.ppa_version }}/ubuntu {{ grains['oscodename'] }} main
    - keyid: C300EE8C
    - keyserver: keyserver.ubuntu.com
    {% endif %}
    {% if salt['grains.get']('osrelease') in ['16.04'] %}
    - require_in:
      - pkg: nginx_install
    - watch_in:
      - pkg: nginx_install
    {% endif %}
nginx_phusionpassenger_repo:
  pkgrepo:
    {%- if from_phusionpassenger %}
    - managed
    {%- else %}
    - absent
    {%- endif %}
    - humanname: nginx phusionpassenger repo
    - name: deb https://oss-binaries.phusionpassenger.com/apt/passenger {{ grains['oscodename'] }} main
    - file: /etc/apt/sources.list.d/nginx-phusionpassenger-{{ grains['oscodename'] }}.list
    - keyid: 561F9B9CAC40B2F7
    - keyserver: keyserver.ubuntu.com
    {% if salt['grains.get']('osrelease') in ['16.04'] %}
    - require_in:
      - pkg: nginx_install
    - watch_in:
      - pkg: nginx_install
    {% endif %}
  
  {% if salt['grains.get']('osrelease') in ['18.04'] %}
    {%- if from_phusionpassenger %}
nginx_phusionpassenger_install:
  pkg.installed:
    - pkgs:
      - dirmngr
      - gnupg
      - apt-transport-https
      - ca-certificates
      - nginx-extras
      - libnginx-mod-http-passenger
    - require:
      - pkgrepo: nginx-official-repo
    - require:
      - pkgrepo: nginx_phusionpassenger_repo
    {% endif %}
  {% endif %}

{% elif salt['grains.get']('os_family') == 'RedHat' %}
nginx_yum_repo:
  pkgrepo:
    {%- if nginx.install_from_repo %}
    - managed
    {%- else %}
    - absent
    {%- endif %}
    - humanname: nginx repo
    - name: nginx
    {%- if salt['grains.get']('os') == 'CentOS' %}
    - baseurl: 'http://nginx.org/packages/centos/$releasever/$basearch/'
    {%- else %}
    - baseurl: 'http://nginx.org/packages/rhel/{{ nginx.rh_os_releasever }}/$basearch/'
    {%- endif %}
    - gpgcheck: {{ nginx.gpg_check }}
    - gpgkey: {{ nginx.gpg_key }}
    - enabled: True
    - require_in:
      - pkg: nginx_install
    - watch_in:
      - pkg: nginx_install

nginx_phusionpassenger_yum_repo:
  pkgrepo:
    {%- if from_phusionpassenger %}
    - managed
    {%- else %}
    - absent
    {%- endif %}
    - humanname: nginx phusionpassenger repo
    - name: passenger
    - baseurl: 'https://oss-binaries.phusionpassenger.com/yum/passenger/el/$releasever/$basearch'
    - repo_gpgcheck: 1
    - gpgcheck: 0 
    - gpgkey: 'https://packagecloud.io/gpg.key'
    - enabled: True
    - sslverify: 1
    - sslcacert: /etc/pki/tls/certs/ca-bundle.crt
    - require_in:
      - pkg: nginx_install
    - watch_in:
      - pkg: nginx_install
{% endif %}