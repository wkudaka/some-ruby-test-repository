

# Instalação  
Para ter menos problemas com configuração de ambiente foi usado o Docker:  
1. [Link com informações de instalação do Docker](https://www.docker.com/products/docker)    
2. [Link de instalação do Docker-compose](https://docs.docker.com/compose/install/)

Feito a instalação do Docker, entre no diretório da aplicação e execute o seguinte comando:  
```bash
docker-compose up
```

Esse comando irá configurar um container e rodar um servidor na porta 3000 da sua maquina local.  



# Sobre a aplicação

Essa aplicação foi desenvolvida em Ruby on Rails (4.2.6) junto com a gem "rails-api".  
Pelo problema envolver grafos, guardar os dados em um banco de dados relacionado a grafos é a melhor solução, fiz uma pesquisa e o mais promissor foi o [Neo4j](https://neo4j.com/), a instalação foi fácil, é bem fácil achar tutoriais (a comunidade é grande), é [ACID](https://en.wikipedia.org/wiki/ACID), possui gems em ruby que auxiliam na conexão com o banco de dados e grandes empresas usam ele, [link com uma lista de clientes](https://neo4j.com/customers/)


# Como usar
Link para criação de malhas:  
POST http://localhost:3000/logistic_meshes  
Para criar uma malha será necessário fazer uma requisição POST para o link acima com os seguintes parâmetros:

| Parâmetro        | Tipo | Descrição           | Exemplo  |
| ------------- |:----------:|---:| -----:|
| name      | String | Nome do mapa|SP |
| mesh      | File  | Arquivo com os pontos  e suas distâncias    |   [Link com arquivo de exemplo](https://gist.github.com/wkudaka/23e38a96655075556eeed7cf630fec93) |

 Uma requisição POST pode ser enviada por ferramentas como o [Postman](https://www.getpostman.com/) ou o **curl**.  
 Exemplo com **curl**:  

 ```bash
curl --form "mesh=@test.txt;filename=desired-filename.txt" --form name=SP  http://localhost:3000/logistic_meshes
```

GET http://localhost:3000/logistic_meshes  
Para consultar uma listagem de mapas, será necessário fazer uma requisição via GET para o link acima com os seguintes parâmetros:
| Parâmetro        | Tipo        | Descrição   | Exemplo  | Valor Default |
| ------------- |:----------:|---:| -----:| --------:|
| per_page      | Integer | Itens por página (até 100 itens) | 5 | 10 |
| actual_page      | Integer      | Página atual |   3  | 1 |
| name      | String     | Filtragem por nome |   SP  | - |

Uma requisição GET pode ser enviada pelo navegador mesmo, exemplo:  
http://localhost:3000/logistic_meshes?per_page=1&actual_page=1&name=SP

GET http://localhost:3000/logistic_meshes/route  
Para consultar o menor caminho entre 2 pontos, será necessário fazer uma requisição via GET para o link acima com os seguintes parâmetros:  

| Parâmetro        | Tipo        | Descrição   | Exemplo  |
| ------------- |:----------:|---:| -----:|
| map_name      | String | Nome do mapa|SP |
| origin      | String      | Ponto de origem |   A  |
| destiny      | String     | Ponto de destino |   D  |
| autonomy      | Float     | Autonomia do caminhão (km/l) |   10  |
| liter_value      | Float  | Valor do litro do combustível    |   2.5  |

Uma requisição GET pode ser enviada pelo navegador mesmo, exemplo:  
http://localhost:3000/logistic_meshes/route?map_name=SP&origin=A&destiny=D&autonomy=10&liter_value=2.5

# Algumas considerações  
- Não alterei o formato do arquivo de exemplo, pois não sei como serão feitos os testes em malhas maiores, mas recomendaria o uso de arquivos em formato CSV, assim os nomes dos pontos de origem/destino podem ter espaços sem muitos problemas.   
- Se esse serviço for ficar em um ambiente aberto (em cloud, sem nenhuma restrição de firewall), seria bom colocar uma camada de autenticação (OAuth2)
