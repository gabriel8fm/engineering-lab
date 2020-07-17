{% from "users/map.jinja" import users with context %}
{% from "users/map.jinja" import dev_users with context %}

# General Present Users
{% for username, attributes in users.items() if attributes.absent is not defined %}
{{ username }}:
  user.present:
    - password: '{{ attributes.password }}'
{% endfor %}

{% if (dev_users is defined) and dev_users -%}
# Dev present users
{% for username, attributes in dev_users.items() if attributes.absent is not defined %}
{{ username }}:
  user.present:
    - password: '{{ attributes.password }}'
{% endfor %}
{% endif -%}
