{% from "newrelic/map.jinja" import newrelic with context %}

include:
  - .nrsysmond

newrelic_config_shared_system:
  file.managed:
    - name: {{ newrelic.dir }}/shared/system/config/newrelic.yml
    - source: salt://{{ slspath }}/files/ruby/newrelic.yml
    - template: jinja

newrelic_config_current:
  file.managed:
    - name: {{ newrelic.dir }}/current/config/newrelic.yml
    - source: salt://{{ slspath }}/files/ruby/newrelic.yml
    - template: jinja

reload-ruby-application:
  cmd.run:
    - name: touch {{ newrelic.dir }}/current/tmp/restart.txt
    - onchanges:
      - file: newrelic_config_current
    

