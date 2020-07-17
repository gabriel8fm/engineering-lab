invoke_orchestrate_file:
  runner.state.orchestrate:
    - args:
        - mods: orchestrate.smessage.set-master.sls
        - pillar:
            event_tag: {{ tag }}
            event_data: {{ data|json }}