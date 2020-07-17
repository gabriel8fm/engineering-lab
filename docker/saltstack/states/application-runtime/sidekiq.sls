sidekiq_config:
  file.managed:
    - name: /lib/systemd/system/sidekiq.service
    - user: root
    - group: root
    - mode: 640
    - source: salt://{{ slspath }}/files/sidekiq.service.jinja
    - template: jinja
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: sidekiq_config

sidekiq_service:
  service.running:
    - name: sidekiq
    - enable: true

check_if_enabled:
  cmd.run:
    - name: /bin/systemctl is-enabled sidekiq.service
