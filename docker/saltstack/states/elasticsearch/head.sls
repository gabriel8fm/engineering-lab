{% from "elasticsearch/map.jinja" import elasticsearch_map with context %}

include:
  - nodejs.npm
  - git

head_app:
  git.latest:
    - name: {{ elasticsearch_map.plugins.head.repo }}
    - target: {{ elasticsearch_map.plugins.head.dir }}
    - require:
      - pkg: git

head_dependencies:
  npm.bootstrap:
    - name: {{ elasticsearch_map.plugins.head.dir }}
    - require:
      - sls: nodejs.npm
      - git: head_app

head_start:
  cmd.run:
    - name: nohup npm start
    - cwd: {{ elasticsearch_map.plugins.head.dir }}
    - bg: true
    - unless: ps aux | grep 'grunt server' | grep -v grep
