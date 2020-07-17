{% from "deploy/map.jinja" import app, deploy with context %}

# Formula must execute only on master

include: 
  - git

fetch_app_repo:
  git.latest:
    - name: {{ app.repo }}
    - target: /srv/salt/deploy/{{ app.dir_name }}/cached-copy
    - rev: {{ deploy.tag }}
    - force_reset: True
    # - identity: /root/.ssh/deploy_key
    - identity:  /srv/salt/deploy/deploy_key

prepare_release_dir:
  file.copy:
    - name: /srv/salt/deploy/{{ app.dir_name }}/{{ deploy.time }}
    - source: /srv/salt/deploy/{{ app.dir_name }}/cached-copy
    - require:
      - git: fetch_app_repo

prepare_deploy_package:
  module.run:
    - name: archive.tar
    - options: czf
    - tarfile: /srv/salt/deploy/{{ app.dir_name }}/deploy.tar.gz 
    - cwd: /srv/salt/deploy/{{ app.dir_name }}/
    - sources: ./{{ deploy.time }}
    - require:
      - file: prepare_release_dir

remove_release_dir:
  file.absent:
    - name: /srv/salt/deploy/{{ app.dir_name }}/{{ deploy.time }}
    - require:
      - module: prepare_deploy_package
