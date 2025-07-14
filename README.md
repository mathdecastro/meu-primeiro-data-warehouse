# Meu primeiro Data Warehouse

Este projeto tem como objetivo demonstrar as minhas habilidades práticas de engenharia de dados em um cenário real de construção de um data warehouse.

## 🏗️ Arquitetura

Neste projeto será utilizada a Arquitetura de Dados Medalhão, em que são definidas as camadas **Bronze**, **Prata** e **Ouro**:

![alt text](docs/images/arquitetura.png)

#### Camadas

1. **Bronze**: Nesta camada temos os dados brutos, da maneira que vieram da fonte de dados. Basicamente, são arquivos CSV que serão inseridos em uma base de dados do PostgreSQL.
2. **Prata**: Nesta camada faremos a limpeza, padronização e normalização dos dados, criaremos colunas derivadas e faremos um enriquecimento dos dados.
3. **Ouro**: Nesta camada iremos aplicar regras de negócio aos dados, faremos uma modelagem do tipo Star Schema e nos responsabilizamos de preparar os dados para que os stakeholders possam consumir e tirar insights.