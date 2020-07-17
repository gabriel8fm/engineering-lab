{%- from "newrelic/map.jinja" import newrelic with context -%}

include:
  - .nrsysmond

newrelic-php5:
  pkg.latest:
    - require:
      - pkg: newrelic-sysmond
    - pkgs:
      - newrelic-php5
        
newrelic_php_config:
  file.managed:
    - name: {{ newrelic.config_dir }}
    - source: salt://{{ slspath }}/files/php/newrelic.ini
    - template: jinja
    - require:
      - pkg: newrelic-php5
      
# Daemon config must not exist in order to use the auto start      
newrelic-daemon_config_absent:
  file.absent:
    - name: /etc/newrelic/newrelic.cfg
    - order: first

reload-php-application:
  cmd.run:
  {% if salt['pkg.list_pkgs']().get('php-fpm', False) -%}
    - name: service {{ newrelic.service }} reload
  {% else -%}
    - name: service httpd graceful
  {% endif -%}   
    - onchanges:
      - pkg: newrelic-php5
      - file: newrelic_php_config

# Newrelic daemon only necessary if running in external method
#
#newrelic-daemon:
#  service.running:
#    - enable: True
#    - full_restart: True
#    - require:
#      - file: newrelic-daemon-config
#    - watch:
#      - file: newrelic_php_config
#    
#newrelic-daemon-config:
#  file.managed:
#    - name: /etc/newrelic/newrelic.cfg
#    - source: salt://{{ slspath }}/files/php/newrelic.cfg
#    
