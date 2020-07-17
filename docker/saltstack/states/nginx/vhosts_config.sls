# nginx.vhosts_config
#
# Manages the configuration of virtual host files.

{% from 'nginx/map.jinja' import nginx, sls_block, file_path, file_curpath with context %}
{% set vhosts_states = [] %}

# Creates the sls block that manages symlinking / renaming servers
{% macro manage_status(server, state) -%}
  {%- set anti_state = {True:False, False:True}.get(state) -%}
  {% if state == True %}
    {%- if nginx.server_use_symlink %}
  file.symlink:
    {{ sls_block(nginx.vhosts.symlink_opts) }}
    - name: {{ file_path(server, state, 'vhosts') }}
    - target: {{ file_path(server, anti_state, 'vhosts') }}
    {%- else %}
  file.rename:
    {{ sls_block(nginx.vhosts.rename_opts) }}
    - name: {{ file_path(server, state, 'vhosts') }}
    - source: {{ file_path(server, anti_state, 'vhosts') }}
    {%- endif %}
  {%- elif state == False %}
    {%- if nginx.server_use_symlink %}
  file.absent:
    - name: {{ file_path(server, anti_state, 'vhosts') }}
    {%- else %}
  file.rename:
    {{ sls_block(nginx.vhosts.rename_opts) }}
    - name: {{ file_path(server, state, 'vhosts') }}
    - source: {{ file_path(server, anti_state, 'vhosts') }}
    {%- endif -%}
  {%- endif -%}
{%- endmacro %}

# Makes sure the enabled directory exists
nginx_server_enabled_dir:
  file.directory:
    {{ sls_block(nginx.vhosts.dir_opts) }}
    - name: {{ nginx.server_enabled }}

# If enabled and available are not the same, create available
{% if nginx.server_enabled != nginx.server_available -%}
nginx_server_available_dir:
  file.directory:
    {{ sls_block(nginx.vhosts.dir_opts) }}
    - name: {{ nginx.server_available }}
{%- endif %}

# Managed enabled/disabled state for servers
{% for server, settings in nginx.vhosts.managed.items() %}
{% if settings.config != None %}
{% set conf_state_id = 'vhost_conf_' ~ loop.index0 %}
{{ conf_state_id }}:
  file.managed:
    {{ sls_block(nginx.vhosts.managed_opts) }}
    - name: {{ file_curpath(server, 'vhosts') }}
    - source: salt://nginx/files/vhost.conf.jinja
    - template: jinja
    - context:
        config: {{ settings.config|json() }}
    {% if 'overwrite' in settings and settings.overwrite == False %}
    - unless:
      - test -e {{ file_curpath(server, 'vhosts') }}
    {% endif %}
{% do vhosts_states.append(conf_state_id) %}
{% endif %}

{% if settings.enabled != None %}
{% set status_state_id = 'vhost_state_' ~ loop.index0 %}
{{ status_state_id }}:
{{ manage_status(server, settings.enabled) }}
{% if settings.config != None %}
    - require:
      - file: {{ conf_state_id }}
{% endif %}

{% do vhosts_states.append(status_state_id) %}
{% endif %}
{% endfor %}