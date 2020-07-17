python-pip:
  pkg.installed

pyvmomi:
  pip.installed:
    - require:
      - pkg: python-pip

cloud_providers:
   file.recurse:
    - name: /etc/salt/cloud.providers.d
    - source: salt://{{ slspath }}/files/cloud.providers.d
    - template: jinja
    
cloud_profiles:
   file.recurse:
    - name: /etc/salt/cloud.profiles.d
    - source: salt://{{ slspath }}/files/cloud.profiles.d
    - template: jinja

cloud_maps:
   file.recurse:
    - name: /etc/salt/cloud.maps.d
    - source: salt://{{ slspath }}/files/cloud.maps.d
    - template: jinja