# nginx.certificates
#
# Manages the nginx certificate files.

include:
  - nginx.service

{%- for domain in salt['pillar.get']('nginx:certificates', {}).keys() %}

nginx_{{ domain }}_ssl_certificate:
  file.managed:
    - name: /etc/nginx/ssl/{{ domain }}.crt
    - makedirs: True
    - contents_pillar: nginx:certificates:{{ domain }}:public_cert
    - watch_in:
      - service: nginx_service

{% if salt['pillar.get']("nginx:certificates:{}:private_key".format(domain)) %}
nginx_{{ domain }}_ssl_key:
  file.managed:
    - name: /etc/nginx/ssl/{{ domain }}.key
    - mode: 600
    - makedirs: True
    - contents_pillar: nginx:certificates:{{ domain }}:private_key
    - watch_in:
      - service: nginx_service
{% endif %}
{%- endfor %}