
{% from "salt/map.jinja" import salt_pillar with context %}

# include:
#  - .repo
  
salt-minion:
  pkg.latest:
    - name: {{ salt_pillar.pkg }}
    #- require:
    #  - pkg: salt-repo
  service.running:
    - name: salt-minion
    - require:
      - pkg: salt-minion
    - enable: True
    - watch:
      - pkg: salt-minion
    # - refresh: True

set_master_address:
  file.replace:
    - name: /etc/salt/minion
    - pattern: '#master: salt'
    - repl: 'master: {{ salt_pillar.master_address }}'
    - require:
        - pkg: salt-minion

salt-minion_config:
  file.managed:
    - name: /etc/salt/minion
    - source: salt://{{ slspath }}/files/minion.jinja
    - template: jinja

salt-minion.d_config:
  file.recurse:
    - name: /etc/salt/minion.d
    - template: jinja
    - source: salt://{{ slspath }}/files/minion.d
    - exclude_pat: _*
    - context:
        standalone: False

at:
  pkg.installed: []
  service.running: 
    - name: atd
        
restart_minion:
  cmd.run:
    - name: echo salt-call --local service.restart salt-minion | at now + 1 minute
    - require:
      - pkg: at
    - order: last
    - onchanges:
      - file: set_master_address
      - file: salt-minion_config
      - file: salt-minion.d_config
      - pkg: salt-minion

{% if 'inotify' in  salt_pillar.get('minion', {}).get('beacons', {}) and salt_pillar.get('pyinotify', False) %}
salt-minion-beacon-inotify:
  pkg.installed:
    - name: {{ salt_pillar.pyinotify }}
    - require_in:
      - service: salt-minion
    - watch_in:
      - service: salt-minion
{% endif %}
