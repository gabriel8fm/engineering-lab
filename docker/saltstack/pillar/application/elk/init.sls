app:
  users:
    user:
      password: '*K*'

elasticsearch:
  version: 6.3.2
  config:
    network.host: ["_local_", "192.168.6.135"]
    network.publish_host: ["192.168.6.135"]
    node.name: server_1
    node.master: true
    node.data: true
    node.ingest: true
    discovery.zen.ping.unicast.hosts: ["192.168.6.135"]
    cluster.name: search
    path.data: /srv/data
    path.logs: /srv/logs
    discovery.zen.minimum_master_nodes: 1
    action.destructive_requires_name: true
  sysconfig:
    ES_STARTUP_SLEEP_TIME: 5
    MAX_OPEN_FILES: 65535
    ES_JAVA_OPTS: '"-Xms4g -Xmx4g"'

kibana:
  repoVersion: '6'
  lookup:
    sourceInstallPath: "/etc/kibana/"
  source: false
  config:
    server.port: '5601'
    server.host: '""'
    server.basePath: '"/kibana"'
    server.maxPayloadBytes: '1048576'
    server.name: '"elk"'
    elasticsearch.url: '"http://elk:9200"'
  plugins:
    x-pack: x-pack
