{% from "network/map.jinja" import network with context %}
{% from "network/map.jinja" import is_resolvconf_enabled with context %}

resolv_config:
  file.managed:
    {% if is_resolvconf_enabled %}
    - name: /etc/resolvconf/resolv.conf.d/base
    {% else %}
    - name: /etc/resolv.conf
    {% endif %}
    - source: salt://{{ slspath }}/files/dns/resolv.conf
    - template: jinja

{% if is_resolvconf_enabled %}
resolv_update:
  cmd.run:
    - name: resolvconf -u
    - onchanges:
      - file: resolv_config
{% endif %}