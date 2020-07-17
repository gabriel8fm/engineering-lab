{% from 'yarn/map.jinja' import yarn with context %}

yarn-install:
  pkg.installed:
    {% if grains['os_family'] == 'Debian' -%}
    - name: {{ yarn.pkg }}
    - require:
      - pkgrepo: yarn-repo
    {% elif grains['os_family'] == 'RedHat' -%}
    - require:
      - pkgrepo: yarn-repo
    {% endif %}