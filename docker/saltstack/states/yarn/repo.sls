{% from 'yarn/map.jinja' import yarn with context %}

yarn-repo:
  {% if grains['os_family'] == 'Debian' -%}
  pkgrepo.managed:
    - name: {{ yarn.reponame }}
    - key_url: {{ yarn.gpgkey }}
  {% elif grains['os_family'] == 'RedHat' -%}
  pkg.installed:
    - cmd.run:
      - name: wget https://dl.yarnpkg.com/rpm/yarn.repo -O /etc/yum.repos.d/yarn.repo && yum install yarn
  {% endif %}