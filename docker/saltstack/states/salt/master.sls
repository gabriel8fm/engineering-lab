# salt-master:
#   pkg.latest:
#     - name: salt-master
#     #- require:
#     #  - pkg: salt-repo
#   service.running:
#     - name: salt-master
#     - require:
#       - pkg: salt-master
#     - enable: True
#     - watch:
#       - pkg: salt-master

master_config:
  file.managed:
    - name: /etc/salt/master
    - source: salt://{{ slspath }}/files/master
    - template: jinja

salt-master.d_config:
  file.recurse:
    - name: /etc/salt/master.d
    - template: jinja
    - source: salt://{{ slspath }}/files/master.d
    - exclude_pat: _*
    - context:
        standalone: False

salt-master:
  service.running:
    - watch:
      - file: master_config

at:
  pkg.installed: []
  service.running: 
    - name: atd

restart_master:
  cmd.run:
    - name: echo salt-call --local service.restart salt-master | at now + 1 minute
    - require:
      - pkg: at
    - order: last
    - onchanges:
      - file: master_config
      - file: salt-master.d_config
      # - pkg: salt-master
