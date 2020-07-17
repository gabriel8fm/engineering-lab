# nginx.config
#
# Manages the main nginx server configuration file.

{% from 'nginx/map.jinja' import nginx, sls_block with context %}

include:
    - nginx.service

{% if nginx.install_from_source %}
nginx_log_dir:
  file.directory:
    - name: /var/log/nginx
    - user: {{ nginx.server.config.user }}
    - group: {{ nginx.server.config.user }}
{% endif %}

nginx_config:
  file.managed:
    {{ sls_block(nginx.server.opts) }}
    - name: {{ nginx.conf_file }}
    # - source: salt://{{ slspath }}/files/nginx.conf.jinja
    - source: salt://{{ slspath }}/files/nginx.conf.jinja
    - template: jinja
    - context:
        config: {{ nginx.server.config|json() }}
    - watch_in:
        - service: nginx_service