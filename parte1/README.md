# iti Platform Challenge

# parte1

# Containerização da aplicação
O arquivo [Dockerfile](/parte1/Dockerfile) contém as configurações para criar a imagem docker da aplicação.
Para executá-lo, utilize o comando na raiz do projeto:
```shell script
docker build . -f ./parte1/Dockerfile  -t <image_name>:<image_version>
```
Onde <i>image_name</i> é o nome da imagem que se deseja criar e <i>image_version</i> sua versão.

<b>obs.:</b> é importante notar que se deve rodar o comando na raiz do projeto devido ao contexto
utilizado pelo docker. 

