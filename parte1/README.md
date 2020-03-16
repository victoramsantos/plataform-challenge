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


# Deploy da aplicação
O Ci/Cd da aplicação foi feito utilizado o [GitLab Ci](https://docs.gitlab.com/ee/ci/). Todo commit relizado no repositório
do [GitHub](https://github.com/victoramsantos/plataform-challenge/) dispara a execução do arquivo [.gitlab-ci.yml](../.gitlab-ci.yml).
Este arquivo contém quatro stages (3 [parte1](../parte1) e 1 [parte2](../parte2)) e jobs que são executados em cada um destes stages.

## Stage: Build
### gradle_build
Executa o build da aplicação. Este job não possuí contexto de branche, logo todo push realizado no repositório ele é
invocado (serve para validaros Pull Requests também).
Por fim, este job gera um artefato (o .jar utilizado na construção da imagem docker) e o mantém no cache.
Vale ressaltar que este job é realizado utilizando a imagem docker java:8-jdk.

## Stage: packing
### docker_build_push
Este job constroi uma imagem docker e a envia para o repositório de imagens da aplicação no [docker hub](https://hub.docker.com/repository/docker/victoramsantos/plataform-challenge).
Para realizar o push das imagens, este job precisa realizar o login no registry do docker hub. Para isso, utilizamos
as variáveis de ambiente do GitLab no modo Secret.
Após o login, podemos realizar o push da imagem. Utilizamos para tag da imagem o short hash commit da branch atual. Isso
é feito utilizando a variável de ambiente padrão do GitLab CI_COMMIT_SHORT_SHA.
Vale ressaltar que este job possuí escopo de chamada para branch master. Isso é feito para não acontecer o deploy para qualquer
commit realizado no repositório.
Por fim, este job é utiliza a imagem docker:18.09.7 para rodar e o serviço docker:18.09.7-dind (Docker inside Docker), 
para conseguir executar comandos docker dentro de um container.

## Stage: deploy_minikube
### init_minikube_ec2
Este job executa algumas ações para garantir que o minikube esteja configurável e funcionando. 
Ele começa parando o serviço do minikube e depois o inicializando novamente. Após isso, inicializa o Tiller do Helm e
habilita o serviço do metrics-server para utilização do Horizontal Pod Autoscaler (HPA).
Este job é excutado por um runner rodando em uma máquina Ec2. Este runner está configurado na conta do GitLab e é acionado
pela tag ec2-runner. 

### deploy_minikube_ec2
Este job realiza o deploy da aplicação no minikube utilizando o [chart helm](plataform-challenge). Ele instala o serviço
utilizando o comando upgrade do helm com o parâmetro --install, o qual instala a aplicação caso ela ainda não exista. 
Esta instrução também altera a imagem padrão da aplicação no chart utilizando o parâmetro --set-string e a variável 
image.tag localizado no arquivo [values.yaml](plataform-challenge/values.yaml), para o short hash commit utilizado ao 
realizar o build da image. Após isso, ele utiliza o comando rollout do kubectl para aguardar a finalização do deploy da 
aplicação.
Por fim, ele utiliza o minikube para expor o serviço, porém é necessário acessar a Ec2 do runner para acessar o serviço.

### rollback_minikube_ec2
Este job realiza o rollback do deploy realizado. Ele altera o serviço atual para o último serviço. 

# Débitos técnicos
Débito | Motivo
------------ | -------------
Rollback automático | Não consegui encontrar uma maneira de se fazer isso direto pela pipeline (.gitlab-ci.yml). Acabei por criar um job de rollback manual (extremamente desaconselhado para ambientes de produção).
Pipeline compartilhada | Não encontrei uma maneira eficiente de se criar pipelines compartilhadas, aos modes do jenkins shared-libraries. 
DNS para aplicação (parte1) | Não foi implementado a resolução de DNS para o ip retornado pelo minikube
Versionamento da aplicação no Chart (appVersion) | Não achei uma maneira de usar o values.yaml para alterar a propriedade appVersion no Chart.yaml
Expor serviço para acesso externo | Não foi implementado uma maneira de expor o serviço para acesso externo ao minikube.