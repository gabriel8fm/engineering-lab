{% set tag = salt.pillar.get('event_tag') %}
{% set data = salt.pillar.get('event_data') %}
{% set env =  salt.pillar.get('env', tag.split("/")[-2]) %}
{% set master =  salt.pillar.get('master', tag.split("/")[-1]) %}
{% if master == '' %}
  {% set slave =  '' %}
{% else %}
  {% set slave =  '' %}
{% endif %}

stop_workers_on_slave:
  salt.state:
    - tgt: {{ env }}_cron-{{ slave }}
    - tgt_type: nodegroup 
    - sls:
      - smessage.workers.down

start_workers_on_master:
  salt.state:
    - tgt: {{ env }}_cron-{{ master }}
    - tgt_type: nodegroup 
    - sls:
      - smessage.workers.up
