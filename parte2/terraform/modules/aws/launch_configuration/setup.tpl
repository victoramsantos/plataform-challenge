#!/bin/bash

sudo yum update -y
sudo amazon-linux-extras install docker
sudo service docker start

mkdir ~/.docker
echo '{
        "auths": {
                "https://index.docker.io/v1/": {
                        "auth": "SECRET"
                }
        },
        "HttpHeaders": {
                "User-Agent": "Docker-Client/19.03.6-ce (linux)"
        }
}' > ./test.txt

export SECRET=${credential}
sed -i s/SECRET/$SECRET/g ~/.docker/config.json

sudo docker run -p${ec2_port}:${container_port} ${image}