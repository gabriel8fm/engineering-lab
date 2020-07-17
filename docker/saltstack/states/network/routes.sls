{% from "network/map.jinja" import network with context %}

routes:
  network.routes:
  {% for name, interface in network.interfaces.items() if interface.routes is defined %}
    - name: {{ name }}
    - routes:
    {% for route in interface.routes %}
      - name: {{ route.name }}
        ipaddr: {{ route.ipaddr }}
        netmask: {{ route.netmask }}
        gateway: {{ route.gateway }}
    {% endfor %}
  {% endfor %}
