#  curl -sk -X POST -v https://localhost:8000/hook/deploy/app_name/test/dc/tag_number
# salt-run state.orch orchestrate.deploy pillar='{"app": {"dir_name": "certapp", "repo": "git@github.com:group/repo.git"}, "deploy": {"tag": "tag_number", "target": ["minion.to.deploy"] }}"

{% set tag = salt.pillar.get('event_tag') %}
{% set data = salt.pillar.get('event_data') %}
{% set deploy = salt.pillar.get('deploy') %}
{% set app =  salt.pillar.get('app', tag.split("/")[-4]) %}
{% set area =  salt.pillar.get('deploy:area', tag.split("/")[-3]) %}
{% set env =  salt.pillar.get('deploy:env', tag.split("/")[-2]) %}
{% set tag =  salt.pillar.get('deploy:tag', tag.split("/")[-1]) %}

{% set app_pillar = { 'app': {'dir_name': app.dir_name, 'repo': app.repo }, 'deploy': deploy.tag } %}

prepare_deploy_file_on_master:
  salt.state:
    - tgt: saltstack-master  
    - sls:
      - deploy.prepare
    - pillar: {{ app_pillar }}

update_release_on_minion:
  salt.state:
    - tgt: {{ deploy.target }} 
    - sls:
      - deploy.update

publish_release_on_minion:
  salt.state:
    - tgt: {{ deploy.target }} 
    - sls:
      - deploy.publish

finish_release_on_minion:
  salt.state:
    - tgt: {{ deploy.target }} 
    - sls:
      - deploy.finish
