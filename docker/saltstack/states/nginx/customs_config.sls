# nginx.customs_config
#
# Manages the configuration of custom files.

{% from 'nginx/map.jinja' import nginx, sls_block, file_curpath with context %}
{% set customs_states = [] %}

# Managed enabled/disabled state for servers
{%- if nginx.customs is defined %}
{%- for server, settings in nginx.customs.managed.items() %}

{% if settings.config != None %}
{% set conf_state_id = 'custom_conf_' ~ loop.index0 %}
{{ conf_state_id }}:
  file.managed:
    {{ sls_block(nginx.customs.managed_opts) }}
    - name: {{ file_curpath(server, 'customs') }}
    - source: salt://nginx/files/nginx.conf.jinja
    - makedirs: True
    - template: jinja
    - context:
        config: {{ settings.config|json() }}
    {% if 'overwrite' in settings and settings.overwrite == False %}
    - unless:
      - test -e {{ file_curpath(server, 'customs') }}
    {% endif %}
{% do customs_states.append(conf_state_id) %}
{% endif %}

{%- endfor %}
{% endif %}
