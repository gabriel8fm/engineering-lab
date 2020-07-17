# {% from "reactor/map.jinja" import slack with context %}

core_tools_notifier_slack:
  local.slack.post_message:
    - tgt: saltstack-master  
    - kwarg:
        channel: "#teste"
        from_name: "Notifier"
        message: "{{ data }}"
