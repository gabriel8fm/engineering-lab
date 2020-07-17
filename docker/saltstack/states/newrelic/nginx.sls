include:
  - nginx.repo
  
newrelic-nginx:
  pkg.latest:
    - require:
      - pkgrepo: nginx-repo
    - pkgs:
      - nginx-nr-agent

newrelic-nginx_config:
  file.managed:
    - name: /etc/nginx-nr-agent/nginx-nr-agent.ini
    - source: salt://{{ slspath }}/files/nginx/nginx-nr-agent.ini.jinja
    - template: jinja
    - context: 
        hostname: "{{ grains['nodename'] }}"
    - require:
      - pkg: newrelic-nginx

newrelic-nginx_daemon:
  service.running:
    - name: nginx-nr-agent
    - enable: True
    - full_restart: True
    - watch:
      - file: newrelic-nginx_config
      - pkg: newrelic-nginx
    - require:
      - pkg: newrelic-nginx
