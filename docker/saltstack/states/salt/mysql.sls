{% set salt_pillar = pillar.get('salt', {}) -%}

include:
  - salt.minion
  - mysql.python

mysql_config:
  file.blockreplace:
    - name: /etc/salt/minion
    - marker_start: "# START salt-minion mysql_config managed zone - DO NOT EDIT #"
    - marker_end: "# END salt-minion mysql_config managed zoned #"
    - content: "mysql.user: {{salt_pillar.mysql.user}} \nmysql.pass: {{salt_pillar.mysql.pass}}\n"
    - append_if_not_found: True
    - require:
        - pkg: salt-minion
        - pkg: mysql_python
    - onchanges_in:
      - cmd: restart_minion