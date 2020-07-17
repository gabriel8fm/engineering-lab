# {% from "reactor/map.jinja" import slack with context %}

{% set apache_running = data['data']['httpd']['running']  %}
{% if not apache_running %}

core_tools_notifier_slack:
  local.slack.post_message:
    - tgt: saltstack-master
    - kwarg:
        channel: "#core-alerts"
        from_name: "Core Notifier"
        message: "*Apache Down:* {{ data['id'] }}"
        api_key: xoxp-2189808731-2200349102-308938552372-a2b89a2cc173209e84929abeaafea691
{% endif %}
