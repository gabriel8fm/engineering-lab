{% from "newrelic/map.jinja" import newrelic with context %}

newrelic-npi:
  cmd.run:
    - name: yes | LICENSE_KEY={{ newrelic.license }} bash -c "$(curl -sSL '{{ newrelic.npi_url }}')"
    
npi_set_license:
  cmd.run:
    - name: cd /newrelic-npi; ./npi config set license_key {{ newrelic.license }}
    - onchanges:
      - cmd: newrelic-npi
