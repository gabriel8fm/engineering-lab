{% from 'redis/map.jinja' import redis with context %}

redis-repo:
  {% if grains['os_family'] == 'Debian' -%}
  pkgrepo.managed:
    - ppa: chris-lea/redis-server
  {% elif grains['os_family'] == 'RedHat' -%}
  pkg.installed:
    - sources:
      - remi-repo: {{ redis.remi_version }}
  {% endif %}