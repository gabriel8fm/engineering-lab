# nginx
#
# Meta-state to fully install nginx.

{% from 'nginx/map.jinja' import nginx, sls_block with context %}

include:
  - nginx.config
  - nginx.service
  - nginx.files
  - nginx.certificates

extend:
  nginx_service:
    service:
      - listen:
        - file: nginx_config
      - require:
        - file: nginx_config
  nginx_config:
    file:
      - require:
        {% if nginx.install_from_source %}
        - cmd: nginx_install
        {% else %}
        - sls: nginx.pkg
        {% endif %}