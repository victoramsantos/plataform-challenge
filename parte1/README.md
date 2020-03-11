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

# Criação do helm chart para aplicação
No diretório [plataform-challenge](/parte1/plataform-challenge) encontra-se as configurações para o helm.
O arquivo [values.yaml](/parte1/plataform-challenge/values.yaml) contém os valores para parametrizar o deploy
da aplicação no cluster Kubernetes. Já o arquivo [Chart.yaml](/parte1/plataform-challenge/Chart.yaml) contém
as informações referentes ao chart.


# Débitos técnicos
Débito | Motivo
------------ | -------------
Rollback automático | Não consegui encontrar uma maneira de se fazer isso direto pela pipeline (.gitlab-ci.yml). Acabei por criar um job de rollback manual (extremamente desaconselhado para ambientes de produção).
Pipeline compartilhada | Não encontrei uma maneira eficiente de se criar pipelines compartilhadas, aos modes do jenkins shared-libraries. 
DNS para aplicação (parte1) | Não foi implementado a resolução de DNS para o ip retornado pelo minikube
Versionamento da aplicação no Chart (appVersion) | Não achei uma maneira de usar o values.yaml para alterar a propriedade appVersion no Chart.yaml 