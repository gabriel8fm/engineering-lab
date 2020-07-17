{% from "rabbitmq/package-map.jinja" import erlang with context %}

erlang-repo:
  pkgrepo.managed:
    - name: {{ erlang.repo }}
    - file: {{ erlang.repofile }}
    - gpgcheck: 1
    - key_url: {{ erlang.repokey }}

erlang-install:
  pkg.installed:
    - name: {{ erlang.pkg }}