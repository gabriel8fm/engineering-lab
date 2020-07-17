salt:
  master:
    # interface: 'XPTO'
    nodegroups:

    reactor:
      - 'salt/beacon/*/load/':
        - salt://reactor/core-tools/slack_notifier/load.sls
      - 'salt/beacon/*/service/':
        - salt://reactor/core-tools/slack_notifier/apache.sls
      - 'salt/netapi/hook/smessage/set-master/*':
        - salt://reactor/smessage/set-master.sls

    api:
      config:
        rest_cherrypy:
        port: 8000
        ssl_crt: /etc/pki/tls/certs/salt-stack.pem
        ssl_key: /etc/pki/tls/certs/salt-stack.key
        debug: true
        expire_responses: false
        log.access_file: /var/log/salt/api
        log_error_file: /var/log/salt/api_error
        webhook_disable_auth: True
        external_auth:
          pam:
            saltstack:
              - .*
