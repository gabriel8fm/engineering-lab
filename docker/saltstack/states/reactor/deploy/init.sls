invoke_deploy_orchestrate_file:
  runner.state.orchestrate:
    - args:
        - mods: orchestrate.deploy.sls
        - pillar:
            event_tag: {{ tag }}
            event_data: {{ data|json }}