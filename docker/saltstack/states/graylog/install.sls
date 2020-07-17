{% from "graylog/map.jinja" import graylog with context %}

include:
  - graylog.repo

graylog-install:
  pkg.installed:
    - name: {{ graylog.package}} 
    - require:
      - pkgrepo: graylog-repo