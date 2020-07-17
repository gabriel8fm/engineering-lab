{% from "salt/map.jinja" import salt_pillar with context %}

salt-repo:
  {% if grains['os_family'] == 'Debian' -%}
  pkgrepo.managed:
    - humanname: Saltstack Debian Repo
    - name: {{ salt_pillar.repo}}
    - file: /etc/apt/sources.list.d/saltstack.list
    - clean_file: True
    # Order: 1 because we can't put a require_in on "pkg: salt-{master,minion}"
    # because we don't know if they are used.
    - order: 1
  {% elif grains['os_family'] == 'RedHat' -%}
  pkgrepo.managed:
    - humanname: SaltStack repo for Red Hat Enterprise Linux $releasever
    - name: saltstack
    - file: /etc/yum.repos.d/saltstack.repo
    - baseurl: {{ salt_pillar.repo }}
    - clean_file: True
    - order: 1
    - enabled: '1'
    - gpgcheck: '1'
    - gpgkey: 'https://repo.saltstack.com/yum/redhat/$releasever/$basearch/latest/SALTSTACK-GPG-KEY.pub
               https://repo.saltstack.com/yum/redhat/$releasever/$basearch/latest/base/RPM-GPG-KEY-CentOS-7'
  {% endif %}