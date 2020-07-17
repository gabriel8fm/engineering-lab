{% from "haproxy/map.jinja" import haproxy with context %}

haproxy-install:
  pkg.installed:
    - name: {{ haproxy.service }} 