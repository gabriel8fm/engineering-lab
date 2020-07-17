include:
  - .repo
  - .nrsysmond
  - .infra
  {% if salt['pkg.list_pkgs']().get('php', False) or salt['pkg.list_pkgs']().get('php-fpm', False) -%}
  - .php
  {% elif salt['file.file_exists']('/usr/local/bin/ruby') %}
  - .ruby
  {% endif %}
