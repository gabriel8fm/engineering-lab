{% from "deploy/map.jinja" import app, deploy with context %}
{% set release_to_delete = salt['cmd.run_all']('ls -xr /var/www/html/app/releases/').stdout.split()[deploy.max_releases:] %}
{% set current_release = salt['cmd.run_all']('ls -xr '~ deploy.releases_dir).stdout.split()[0]%}

## 

{% for release in release_to_delete %}
{% if release %}
cleanup_releases {{ release }}:
  file.absent:
    - name: {{ deploy.releases_dir }}{{ release }}
{% endif %}
{% endfor %}

## Post finish commands
{% for command in deploy.post_finish_commands %}
{% if command %}
post_finish_command {{ command }}:
  cmd.run:
    - name: {{ command }}
    - cwd: {{ deploy.releases_dir }}{{ current_release }} 
{% endif %}
{% endfor %}  