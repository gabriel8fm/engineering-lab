puma_config:
  file.managed:
    - name: /lib/systemd/system/puma.service
    - user: root
    - group: root
    - mode: 640
    - source: salt://{{ slspath }}/files/puma.service.jinja
    - template: jinja
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: puma_config

puma_service:
  service.running:
    - name: puma
    - enable: true

check_if_enabled:
  cmd.run:
    - name: /bin/systemctl is-enabled puma.service
