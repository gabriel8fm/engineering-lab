{% from "deploy/map.jinja" import app, deploy with context %}

## Workflow:
 # - Create directories
 # - Untar

ensure_app_directory:
  file.directory:
    - name: {{ deploy.shared_dir }}
    - user: {{ app.user }}
    - group: {{ app.user }}
    - mode: 770
    - makedirs: True
    - recurse:
        - user
        - group
        - mode

extract_deploy_package:
  archive.extracted:
    - name: {{ deploy.releases_dir }}
    - source: salt://deploy/{{ app.dir_name }}/deploy.tar.gz
    - tarfile: {{ app.dir }}/deploy.tar.gz 
    - user: {{ app.user }}
    - group: {{ app.user }}
    - trim_output: 1