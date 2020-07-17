{% from "tmpwatch/map.jinja" import tmpwatch with context %}

tmpwatch_cron:
  cron.present:
    - identifier: tmpwatch_cron
    - name: {{ tmpwatch.pkg }} -am 12 --exclude=/tmp/.newrelic.sock /tmp
    - hour: 6
    
tmpwatch_wrong_cron:
  cron.absent:
    - name: {{ tmpwatch.pkg }} -am 12 /tmp
    - hour: 6
    
tmpwatch_wrong_cron2:
  cron.absent:
    - name: {{ tmpwatch.pkg }} -am 12 --exclude=/tmp/.newrelic.sock /tmp
    - hour: 6
    
    