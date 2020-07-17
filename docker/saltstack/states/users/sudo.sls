{%- from "users/map.jinja" import dev_users with context %}

include_sudoers.d:
  file.managed:
    - name: /etc/sudoers
    - user: root
    - group: root
    - mode: 440
    - template: jinja
    - source: salt://{{ slspath }}/files/sudoers
    - context:
      included: false
    
infra_sudoers:
  file.managed:
    - name: /etc/sudoers.d/infra
    - source: salt://{{ slspath }}/files/sudo/infra
    - template: jinja

{% if (dev_users is defined) and dev_users -%}
dev_sudoers:
  file.managed:
    - name: /etc/sudoers.d/dev
    - source: salt://{{ slspath }}/files/sudo/dev
    - template: jinja
{% else -%}
# ensure_sudoers.d_is_not_included:
#   file.blockreplace:
#     - name: /etc/sudoers
#     - marker_start: "# START salt managed zone - DO NOT EDIT #"
#     - marker_end: "# END salt managed zoned #"
#     - content: ""
    # - append_if_not_found: True

dev_sudoers_absent:
  file.absent:
    - name: /etc/sudoers.d/dev
{% endif -%}