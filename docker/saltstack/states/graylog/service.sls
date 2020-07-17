{% from "graylog/map.jinja" import graylog with context %}

include:
  - graylog.install

graylog-service:
  service.running:
    - name: {{ graylog.service}}
    - require:
      - pkg: graylog-install
