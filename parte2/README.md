# iti Platform Challenge

# parte2

# Montar uma stack para rodar a aplicação
Para montar a stack da aplicação foi utilizado [terraform](https://www.terraform.io/). Foram criados 2 providers e os 
módulos necessários para eles funcionarem. 
O provider [master_vpc](terraform/providers/aws/stacks/master_vpc) cria uma VPC com 4 subnets, sendo duas públicas e 
duas privadas. Além disso ele também cria um Nat Gateway em uma subnet pública, adicionando rota das subnets privadas
para ele. Isso permite que as instâncias na subnet privada tenham acesso a internet, porém não sejam acessíveis via 
internet. Também foi criado um Internet Gateway para prover acesso a internet a VPC.
Já o provider [deploy_env](terraform/providers/aws/stacks/deploy_env) cria uma stack contendo: 
- 1 Aplication Load Balancer escutando na porta 80 e redirecionando para um Taget Group Listener na porta 80;
- 1 Target Group contendo as instâncias Ec2 verificando a saúde das aplicações no path informado;
- 1 Autoscaling Group que utiliza um Launch Configuration para subir novas instâncias;
- 1 Launch Configuration que está configurado para instâncias t2.micro, AMI default da AWS para Amazon Linux e com
Security Group aberto para o mundo na porta 80. Este Launch Configuration também define um script de [user data](terraform/modules/aws/launch_configuration/setup.tpl)
que realiza o login no docker hub e executa a imagem informada da aplicação. 

# Deploy da aplicação em Ec2
O Ci/Cd da aplicação foi feito utilizado o [GitLab Ci](https://docs.gitlab.com/ee/ci/). Todo commit relizado no repositório
do [GitHub](https://github.com/victoramsantos/plataform-challenge/) dispara a execução do arquivo [.gitlab-ci.yml](../.gitlab-ci.yml).
Este arquivo contém quatro stages (3 [parte1](../parte1) e 1 [parte2](../parte2)) e jobs que são executados em cada um destes stages.

## Stage: build_stack
### build_stack
Este job realiza o provisionamento de recursos na AWS. Ele irá executar a receita do [deploy_env/main.tf](terraform/providers/aws/stacks/deploy_env/main.tf).
Ele também é parametrizado para executar a imagem com tag do short hash commit atual.

### destroy_stack
Este job utiliza o tfstates do deploy_env para destruir a stack criada.


# Débitos técnicos
Débito | Motivo
------------ | -------------
Habilitar conexão SSL no Load Balancer | Criar certificado e habilitar apenas conexão SSL no ALB (ou redirect 80 -> 443).
Políticas de scaling | Utilizar algum serviço para garantir que a aplicação esteja escalando quando houver aumento de requisição
Orquestrador de container | Uma vez que o deploy está sendo realizado utilizando imagens docker, o ideal seria utilizar algum orquestraor de container para gerenciar o ambiente (AWS ECS, Kubernetes)