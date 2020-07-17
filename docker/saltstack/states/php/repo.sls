{% from "php/map.jinja" import fpm with context %}
{% if grains['os_family'] == "RedHat" -%}
ius-repo:
  pkg.installed:
    - sources:
      - repo-ius: {{fpm.repo_ius}}
      - repo-epel: {{fpm.repo_epel}}

{% endif %}