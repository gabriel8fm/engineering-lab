
include:
{% if pillar.zabbix.agent is defined %}
- zabbix.agent
{% endif %}
