{% from "newrelic/map.jinja" import newrelic with context %}

include:
  - .npi
  - java.jre
  - mysql.python
  
newrelic_mysql_install:
  cmd.run:
    - require: 
      - cmd: newrelic-npi
    - name:  cd /newrelic-npi; ./npi install com.newrelic.plugins.mysql.instance -s -y --user newrelic
    - template: jinja
    
newrelic_mysql_config:
  file.managed:
    - name: /newrelic-npi/plugins/com.newrelic.plugins.mysql.instance/newrelic_mysql_plugin-2.0.0/config/newrelic.json
    - source: salt://{{ slspath }}/files/mysql/newrelic.json
    - template: jinja
  
newrelic_user_localhost:
  mysql_user.present:
    - name: {{ newrelic.mysql.user }}
    - password_hash: "{{ newrelic.mysql.password_hash }}"
    - host: {{ newrelic.mysql.host1 }}
  mysql_grants.present:
    - grant: {{ newrelic.mysql.grant }}
    - database: {{ newrelic.mysql.database }}
    - user: {{ newrelic.mysql.user }}
    - host: {{ newrelic.mysql.host1 }}
  require:
    - pkg: mysql_python 

newrelic_user_127.0.0.1:
  mysql_user.present:
    - name: {{ newrelic.mysql.user }}
    - password_hash: "{{ newrelic.mysql.password_hash }}"
    - host: {{ newrelic.mysql.host2 }}
  mysql_grants.present:
    - grant: {{ newrelic.mysql.grant }}
    - database: {{ newrelic.mysql.database }}
    - user: {{ newrelic.mysql.user }}
    - host: {{ newrelic.mysql.host2 }}
  require:
    - pkg: mysql_python 

newrelic_mysql_plugin_config:
  file.managed:
    - name: /newrelic-npi/plugins/com.newrelic.plugins.mysql.instance/newrelic_mysql_plugin-2.0.0/config/plugin.json
    - source: salt://{{ slspath }}/files/mysql/plugin.json
    - template: jinja

fix_mysql_plugin_script:
  file.replace:
    - name: /etc/init.d/newrelic_plugin_com.newrelic.plugins.mysql.instance
    - pattern: "sudo -u root j"
    - repl: "j"

    
newrelic_mysql_plugin_daemon:
  service.running:
    - name: newrelic_plugin_com.newrelic.plugins.mysql.instance
    - enable: True
    - full_restart: True
    - watch:
      - file: newrelic_mysql_config
      - file: newrelic_mysql_plugin_config
  