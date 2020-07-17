jre-install:
  pkg.installed:
    {% if grains['os_family'] == 'Debian' -%}
      - name: default-jre
    {% elif grains['os_family'] == 'RedHat' -%}
      - sources:
        - jre-repo: http://download.oracle.com/otn-pub/java/jdk/8u60-b27/jre-8u60-linux-x64.rpm
    {% endif %}
