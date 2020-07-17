{% from 'memcached/map.jinja' import memcached with context %}

include:
  - memcached

memcached_conf:
  file.managed:
    - name: {{ memcached.config_file }}
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    {% if grains['os_family'] == 'Debian' %}
    - source: salt://memcached/files/debian.memcached.conf.jinja
    {% elif grains['os_family'] == 'RedHat' %}
    - source: salt://memcached/files/redhat.memcached.jinja
    {% endif %}
    - watch_in:
      - service: memcached