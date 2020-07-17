# nginx.service
#
# Manages the nginx service execution.

{% from 'nginx/map.jinja' import nginx, service_function  with context %}

include:
  {% if nginx.install_from_source %}
  - nginx.src
  {% else %}
  - nginx.pkg
  {% endif %}

{% if nginx.install_from_source %}
nginx_systemd_service_file:
  file.managed:
    - name: /lib/systemd/system/nginx.service
    - source: salt://nginx/files/nginx.service
{% endif %} 
  
nginx_service:
  service.{{ service_function }}:
    - name: {{ nginx.service }}
    - enable: {{ nginx.service_enable }}
    - require:
      {% if nginx.install_from_source %}
      - sls: nginx.src
      {% else %}
      - sls: nginx.pkg
      {% endif %}
