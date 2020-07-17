# Setup Elastic Repo
{% from "kibana/map.jinja" import kibana with context %}

kibana-repo:
  {% if grains['os_family'] == 'Debian' -%}
  pkgrepo.managed:
    - humanname: Kibana Repo
    - name: deb {{ kibana.repo_url }} stable main
    - file: /etc/apt/sources.list.d/elasticsearch.list
    - gpgcheck: 1
    - key_url: https://artifacts.elastic.co/GPG-KEY-elasticsearch
    - require_in:
      - pkg: kibana
    - clean_file: true
  {% elif grains['os_family'] == 'RedHat' -%}
  pkgrepo.managed:
    - humanname: Kibana Repo
    - file: /etc/yum.repos.d/kibana.repos
    - baseurl: {{ kibana.repo_url }}
    - gpgcheck: 1
    - key_url: https://artifacts.elastic.co/GPG-KEY-elasticsearch
    - require_in:
      - pkg: kibana
  {% endif %}