{% from "tmpwatch/map.jinja" import tmpwatch with context %}

tmpwatch:
  pkg.installed:
    - name: {{ tmpwatch.pkg }}
    
include:
  - tmpwatch.cron