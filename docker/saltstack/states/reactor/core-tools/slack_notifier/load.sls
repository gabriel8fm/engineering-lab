# {% from "reactor/map.jinja" import slack with context %}

core_tools_notifier_slack:
  local.slack.post_message:
    - tgt: saltstack-master
    - kwarg:
        channel: "#core-alerts"
        from_name: "Core Notifier"
        message: "*Load Alert:* {{ data['id'] }}\n *1m:* {{ data ['1m'] }} *5m:* {{ data ['5m'] }} *15m:* {{ data ['15m'] }}"
        api_key: xoxp-2189808731-2200349102-308938552372-a2b89a2cc173209e84929abeaafea691
