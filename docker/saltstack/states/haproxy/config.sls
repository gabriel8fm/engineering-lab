include:
  - haproxy.pkg

{%- if salt['pillar.get']('haproxy:config') %}
haproxy_cfg:
  file.serialize:
    - name: /etc/haproxy/haproxy.cfg
    - dataset_pillar: haproxy:config
    - formatter: yaml
    - user: root
    - require:
      - sls: haproxy.install
{%- endif %}