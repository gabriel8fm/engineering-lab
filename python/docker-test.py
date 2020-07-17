import docker
objdocker = docker.Client(base_url="unix://var/run/docker.sock")
objdocker.stats_container = objdocker.stats('nome_Container')
for stat in objdocker.stats_container:
print(stat)
