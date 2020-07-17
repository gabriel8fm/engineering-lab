# nginx.files
#
# Manages nginx virtual hosts and custom files and their relationship to the nginx service.

{% from 'nginx/map.jinja' import nginx, sls_block, service_function with context %}
{% from 'nginx/vhosts_config.sls' import vhosts_states with context %}
{% from 'nginx/customs_config.sls' import customs_states with context %}

{% set states = vhosts_states + customs_states %}

{% macro file_requisites(states) %}
      {%- for state in states %}
      - file: {{ state }}
      {%- endfor -%}
{% endmacro %}

include:
  - nginx.service
  - nginx.vhosts_config
  - nginx.customs_config

{% if states|length() > 0 %}
nginx_service_reload:
  service.{{ service_function }}:
    - name: {{ nginx.service }}
    - reload: True
    - use:
      - service: nginx_service
    - listen:
      {{ file_requisites(states) }}
    - require:
      {{ file_requisites(states) }}
      - service: nginx_service
{% endif %}