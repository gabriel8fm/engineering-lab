# nginx.passenger
#
# Manages installation of passenger from repo.
# Requires install_from_phusionpassenger = True

{% from 'nginx/map.jinja' import nginx, sls_block with context %}

{% if salt['grains.get']('os_family') in ['Debian', 'RedHat'] %}
include:
  - nginx.pkg
  - nginx.service

passenger_install:
  pkg.installed:
    - name: {{ nginx.passenger_package }}
    - require:
      - pkg: nginx_install
    - require_in:
      - service: nginx_service

{% endif %}