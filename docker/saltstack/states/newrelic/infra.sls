#newrelic-infra-repo:
#  cmd.run:
#    - name: curl -s https://75aae388e7629eec895d26b0943bbfd06288356953c5777d:@packagecloud.io/install/repositories/newrelic/infra-beta/script.rpm.sh |  bash

newrelic-infra:
  pkg.removed:
    - pkgs:
      - newrelic-infra

#set_newrelic_infra_license:
#  cmd.run:
#    - name: 'echo "license_key: XXXXXX" >> /etc/newrelic-infra.yml'
#    - watch_in:
#      - service: newrelic-infra
#    - watch:
#      - pkg: newrelic-infra
#
#Make sure the newrelic-infra agent is running:
#  service.running:
#    - name: newrelic-infra
#    - enable: True