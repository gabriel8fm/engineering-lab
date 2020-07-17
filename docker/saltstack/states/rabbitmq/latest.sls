{% from "rabbitmq/package-map.jinja" import rabbitmq with context %}
include:
  - rabbitmq

{% if grains['os_family'] == 'Debian' %}
rabbitmq_repo:
  pkgrepo.managed:
    - humanname: RabbitMQ Repository
    - name: {{ rabbitmq.repo }}
    - file: {{ rabbitmq.repofile }}
    - key_url: {{ rabbitmq.repokey }}
    - require_in:
      - pkg: rabbitmq-server
{% elif grains['os'] == 'CentOS' and grains['osmajorrelease'][0] == '6' %}
rabbitmq_repo:
  pkgrepo.managed:
    - humanname: RabbitMQ Packagecloud Repository
    - baseurl: https://packagecloud.io/rabbitmq/rabbitmq-server/el/6/$basearch
    - gpgcheck: 1
    - enabled: True
    - gpgkey: https://packagecloud.io/gpg.key
    - sslverify: 1
    - sslcacert: /etc/pki/tls/certs/ca-bundle.crt
    - require_in:
      - pkg: rabbitmq-server
{% endif %}
