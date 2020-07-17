import docker

objdocker = docker.Client(base_url="unix://var/run/docker.sock")
container = objdocker.create_container(imagem=imagem, command=comando, hostname=host+":4500",mem_limit="1000m",name=nome_Container
objdocker.start(container,port_bindings={port_container: ('0.0.0.0', port_Host)})
