{% from "deploy/map.jinja" import app, deploy with context %}

change_current_to_current_release:
  file.symlink:
    - name: {{ app.dir }}/current
    - target: {{ deploy.releases_dir }}{{ deploy.current_release }}
    - user: {{ app.user }}
    - group: {{ app.user }}
    - mode: 770
    - makedirs: True
    - force: True

## Reload service if stated
{% if deploy.service_to_reload %}
reload_{{ deploy.service_to_reload }}:
  service.running:
    - enable: True
    - reload: True
    - watch:
      - change_current_to_current_release
{% endif %}

## TODO: Identify the running web service and reload it

# {% if salt['pkg.list_pkgs']().get('php', False) or salt['pkg.list_pkgs']().get('php-fpm', False) -%}
# reload-php-application:
#   cmd.run:
#   {% if salt['pkg.list_pkgs']().get('php-fpm', False) -%}
#     - name: service {{ newrelic.service }} reload
#   {% else -%}
#     - name: service httpd graceful
#   {% endif -%}   
#     - onchanges:
#       - pkg: newrelic-php5
#       - file: newrelic_php_config
# {% endif %}


## Post publish commands
{% for command in deploy.post_publish_commands %}
{% if command %}
post_publish_command {{ command }}:
  cmd.run:
    - name: {{ command }}
    - cwd: {{ deploy.releases_dir }}{{ deploy.current_release }}
{% endif %}
{% endfor %}

## Rollback in case any state above fails

change_current_to_previous_release:
  file.symlink:
    - name: {{ app.dir }}/current
    - target: {{ deploy.releases_dir }}{{ deploy.previous_release }}
    - user: {{ app.user }}
    - group: {{ app.user }}
    - mode: 770
    - makedirs: True
    - force: True
    - onfail:
      - change_current_to_current_release
      {% if deploy.service_to_reload %}
      - reload*
      {% endif %}
      {% if deploy.post_publish_commands %}
      - post_publish_command*
      {% endif %}

rollback_update:
  file.absent:
    - name: {{ deploy.releases_dir }}{{ deploy.current_release }}/
    - onfail:
      - change_current_to_current_release
      {% if deploy.service_to_reload %}
      - reload*
      {% endif %}
      {% if deploy.post_publish_commands %}
      - post_publish_command*
      {% endif %}

