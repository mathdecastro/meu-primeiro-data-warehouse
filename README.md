# Meu primeiro Data Warehouse

Este projeto tem como objetivo demonstrar boa parte das minhas habilidades práticas de engenharia de dados em um cenário real de construção de um data warehouse.

## 🏗️ Arquitetura

Neste projeto será utilizada a Arquitetura de Dados Medalhão, em que são definidas as camadas **Bronze**, **Prata** e **Ouro**:

![alt text](docs/images/arquitetura.png)
![alt text](docs/images/arquitetura.svg)

### Camadas

1. **Bronze**: Nesta camada temos os dados brutos, da maneira que vieram da fonte de dados. Basicamente, são arquivos CSV que serão inseridos em uma base de dados do PostgreSQL.
2. **Prata**: Nesta camada faremos a limpeza, padronização e normalização dos dados, criaremos colunas derivadas e faremos um enriquecimento dos dados.
3. **Ouro**: Nesta camada iremos aplicar regras de negócio aos dados, faremos uma modelagem do tipo Star Schema e nos responsabilizamos de preparar os dados para que os stakeholders possam consumir e tirar insights.

## :page_with_curl: Convenções

### Tabelas

#### Regras Gerais

Todas os nomes de tabelas, não importando em qual camada estejam, deverão seguir seguir as seguintes regras:

- Ser em língua portuguesa;
- Seguir a convenção *snake_case*, que é uma convenção onde todas as letras são minúsculas e a separação de palavras é feita por underscore. A seguir, estão alguns exemplos:
    - `crm_corretores`;
    - `intranet_visitas_assessores`;
- Não utilizar comandos em SQL como nome de tabelas;
- Não utilizar acentos.

#### Camada <span style="color:#dd4d2e">Ouro</span>

- Todos os nomes de tabelas nesta camada devem seguir a seguintes regras:
    - Começar com o nome do sistema de origem (e.g., `crm` , `intranet`).
    - Finalizar com o nome da tabela no sistema de origem (e.g., se no intranet há uma fonte de dados escrita “Visitas de Assessores”, então esta tabela na camada bronze se chamaria `intranet_visitas_assessores` ).
    - Em síntese, a nomeação de tabelas nesta camada deverão seguir a seguinte ideia `<nome do sistema de origem>_<nome desta fonte de dados neste sistema de origem>`.

#### Camada <span style="color:#a5a5a5">Prata</span>

- Todos os nomes de tabelas nesta camada devem ser exatamente iguais aos da camada bronze.

#### Camada <span style="color:#fadf59">Ouro</span>

- Todos os nomes de tabelas nesta camada devem seguir a seguintes regras:
    - Começar com a classificação dela na modelagem de dados (e.g., `fato` , `dim`, `agg`);
    - Finalizar com um nome que descreva bem o conteúdo da tabela (e.g., `corretores`, `visitas`, `vendas`);
    - Alguns exemplos: `fato_vendas`, `dim_corretores`, `dim_calendario`, `dim_fornecedores`, `agg_visitas`, `agg_comercial`, `agg_clientes`.