{% from 'redis/map.jinja' import redis with context %}

redis-config:
  file.managed:
    - name: {{redis.config_file}}
    - user: {{redis.user}}
    - group: {{redis.group}}
    - mode: {{redis.mode}}
    - source: {{redis.config_template}}
    - template: {{redis.template}}

redis-service:
  service.running:
    - name: {{ redis.service }}
    - enable: true

redis-reload:
  cmd.run:
    - name: service {{redis.service}} restart
    - onchanges:
      - file: {{redis.config_file}}