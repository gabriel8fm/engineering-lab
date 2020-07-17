{% from "haproxy/map.jinja" import haproxy with context %}

include:
  - haproxy.install

haproxy-service:
  service.running:
    - name: {{ haproxy.service}}
    - require:
      - pkg: haproxy-install