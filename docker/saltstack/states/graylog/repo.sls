{% from "graylog/map.jinja" import graylog with context %}
  
apt-transport-https-install:
  pkg.installed:
    - name: apt-transport-https

graylog-repo:
  pkgrepo.managed:
    - humanname: graylog-repo
    {% if grains['os_family'] == 'RedHat' -%}
    - baseurl: {{ graylog.repo }}
    - gpgcheck: 1
    - gpgkey: salt://{{ slspath }}/files/RPM-GPG-Key
    {% elif grains['os_family'] == 'Debian' -%}
    - name: {{ graylog.repo }}
    - file: /etc/apt/sources.list.d/graylog.list
    - gpgcheck: 1
    - key_url: https://packages.graylog2.org/repo/debian/keyring.gpg
  {% endif %}