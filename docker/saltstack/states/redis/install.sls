{% from 'redis/map.jinja' import redis with context %}

redis-install:
  pkg.installed:
    - name: {{ redis.pkg }}
    {% if grains['os_family'] == 'Debian' -%}
    - require:
      - pkgrepo: redis-repo
    {% elif grains['os_family'] == 'RedHat' -%}
    - enablerepo: {{ redis.repo }}
    {% endif %}

vm.overcommit_memory:
  sysctl.present:
    - value: 1