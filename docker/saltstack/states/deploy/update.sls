{% from "deploy/map.jinja" import app, deploy with context %}
{%- set current_release = salt['cmd.run_all']('ls -xr '~ deploy.releases_dir).stdout.split()[0] %}

## Workflow:
 # - Create directories (include: extract)
 # - Untar (include: extract)
 # - Create tag file
 # - Copy shared/system
 # - Make symlinks
 # - Ensure permissions
 # - Rollback changes if failure

include:
  - deploy.extract

gen_tag_file:
  file.managed:
    - name: {{ deploy.releases_dir }}{{ current_release }}/tag
    - contents: 
      - {{ deploy.tag }}
    - require:
      - extract_deploy_package

## Copy shared/system files and directories

{% for file in deploy.shared_system_files %}
{% if file %}
copy_shared_system {{ file }}:
  file.copy:
    - name: {{ deploy.releases_dir }}{{ current_release }}/{{ file }}
    - source: {{ deploy.shared_dir }}/{{ file }}
    - user: {{ app.user }}
    - group: {{ app.user }}
    - mode: 770
    - makedirs: True
    - force: True
    - require:
      - extract_deploy_package

{% endif %}
{% endfor %}


## Make symlinks for shared/system files and directories

{% for file in deploy.shared_system_files_symlink %}
{% if file %}
symlink_shared_system {{ file }}:
  file.symlink:
    - name: {{ deploy.releases_dir }}{{ current_release }}/{{ file }}
    - target: {{ deploy.shared_dir }}/{{ file }}
    - user: {{ app.user }}
    - group: {{ app.user }}
    - mode: 770
    - makedirs: True
    - force: True
    - require:
      - archive: extract_deploy_package
{% endif %}
{% endfor %}

## Post update commands
{% for command in deploy.post_update_commands %}
{% if command %}
post_update_command {{ command }}:
  cmd.run:
    - name: {{ command }}
    - cwd: {{ deploy.releases_dir }}{{ current_release }} 
{% endif %}
{% endfor %}

ensure_app_permissions:
  file.directory:
    - name: {{ deploy.releases_dir }}{{ current_release }}/
    - user: {{ app.user }}
    - group: {{ app.user }}
    - mode: 770
    - makedirs: True
    - recurse:
        - user
        - group
        - mode
    - require:
      - archive: extract_deploy_package

## Rollback in case any state above fails

rollback_update:
  file.absent:
    - name: {{ deploy.releases_dir }}{{ current_release }}/
    - onfail:
      - ensure_app_directory
      - extract_deploy_package
      - gen_tag_file
      - copy_shared_system*
      - symlink_shared_system*
      - ensure_app_permissions
      # - post_update_command*