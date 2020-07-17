{% set agent = pillar.zabbix.agent %}
{%- if agent.enabled %}
{%- if grains.os_family == "RedHat" %}

{% set zabbix_agent_config = '/etc/zabbix/zabbix_agentd.conf' %}
{% set zabbix_agent_config_disco = '/etc/zabbix/zabbix_agentd.d/userparameter_disk_cpu.conf' %}
{% set zabbix_agent_config_udp_tcp = '/etc/zabbix/zabbix_agentd.d/userparameter_UDP_TCP.conf' %}
{% set zabbix_agent_config_mysql = '/etc/zabbix/zabbix_agentd.d/userparameter_mysql.conf' %}

{% set zabbix_package_present = ['zabbix-agent', 'bc'] %}
{% set zabbix_packages_absent = ['zabbix-agent', 'zabbix'] %}

zabbix_agent_absent_packages:
  pkg.removed:
  - names: {{ zabbix_packages_absent }}

zabbix_agent_packages:
  pkg.installed:
  - names: {{ zabbix_package_present }}

{%- endif %}

{%- if grains.os_family == "Debian" %}

{% set zabbix_agent_config = '/etc/zabbix/zabbix_agentd.conf' %}
{% set zabbix_agent_config_disco = '/etc/zabbix/zabbix_agentd.d/userparameter_disk_cpu.conf' %}
{% set zabbix_agent_config_udp_tcp = '/etc/zabbix/zabbix_agentd.d/userparameter_UDP_TCP.conf' %}
{% set zabbix_agent_config_mysql = '/etc/zabbix/zabbix_agentd.d/userparameter_mysql.conf' %}

zabbix_agent_repo:
  pkgrepo.managed:
  - human_name: Zabbix
  - names:
    - deb http://repo.zabbix.com/zabbix/3.2/ubuntu {{ grains.oscodename }} main
    - deb-src http://repo.zabbix.com/zabbix/3.2/ubuntu {{ grains.oscodename }} main
  - file: /etc/apt/sources.list.d/zabbix.list
  - key_url: salt://zabbix/conf/zabbix-official-repo.key

zabbix_agent_packages:
  pkg.installed:
  - names:
    - zabbix-agent
  - require:
    - pkgrepo: zabbix_agent_repo

{% endif %}

{%- endif %}

zabbix_agent_config:
  file.managed:
  - name: {{ zabbix_agent_config }}
  - source: salt://zabbix/conf/zabbix_agentd.conf
  - template: jinja
  - require:
    - pkg: zabbix_agent_packages

zabbix_agent_config_userparameter_disk_cpu:
  file.managed:
  - name: {{ zabbix_agent_config_disco }}
  - source: salt://zabbix/conf/userparameter/userparameter_disk_cpu.conf
  - template: jinja
  - require:
    - pkg: zabbix_agent_packages

zabbix_agent_config_userparameter_udp_tcp:
  file.managed:
  - name: {{ zabbix_agent_config_udp_tcp }}
  - source: salt://zabbix/conf/userparameter/userparameter_UDP_TCP.conf
  - template: jinja
  - require:
    - pkg: zabbix_agent_packages

zabbix_agent_config_userparameter_mysql:
  file.managed:
  - name: {{ zabbix_agent_config_mysql }}
  - source: salt://zabbix/conf/userparameter/userparameter_mysql.conf
  - template: jinja
  - require:
    - pkg: zabbix_agent_packages

start_service:
   cmd.run:
      - name: 'service zabbix-agent start'
      - user: root
      - group: root

enable_service:
   cmd.run:
      - name: 'systemctl enable zabbix-agent'
      - user: root
      - group: root
