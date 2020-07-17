{% from "newrelic/map.jinja" import newrelic with context %}

include:
  - .repo

newrelic-sysmond:
  pkg.latest:
    - require:
      {% if grains['os_family'] == 'RedHat' -%}
      - pkg: newrelic-repo
      {%- elif grains['os_family'] == 'Debian' -%}
      - pkgrepo: newrelic-repo
      {%- endif %}
    - pkgs:
      - newrelic-sysmond

set_newrelic_license:
  cmd.run:
    - name: nrsysmond-config --set license_key={{ newrelic.license }}
    - onchanges:
      - pkg: newrelic-sysmond

Make sure the newrelic agent is running:
  service.running:
    - name: newrelic-sysmond
    - enable: True
    - watch:
      - cmd: set_newrelic_license
