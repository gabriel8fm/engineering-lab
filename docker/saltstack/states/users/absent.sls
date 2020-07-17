{% from "users/map.jinja" import users with context %}
{% from "users/map.jinja" import users_settings with context %}

# Absent Users
{% for username, attributes in users.items() if attributes.absent is defined and attributes.absent %}
{{ username }}:
  user.absent:
    - force: {{ users_settings.absent_force }}
    - purge: {{ users_settings.absent_purge }}
{% endfor %}
