# Client API - Ruby on Rails api only

## Nesse projeto, vamos desenvolver uma aplicação api-only para um simples cadastro de clientes.

### Vamos precisar das seguintes dependências instaladas:
  - ruby >= 2.6.1
  - Rails >= 5.2.3
  - Postgres >= 9.5.16

> Você também vai precisar instalar a gem ‘pg’, pra isso é só executar no terminal:

```ruby
 $ gem install pg
```

## Iniciando o projeto

### Execute no seu terminal o comando:

```ruby
$ rails new client-api --api --database=postgresql
```
- Aos que são adeptos do VSCode, conseguimos abrir o editor da seguinte forma:

```ruby
 $ cd client-api
 $ code .
```

### Vamos usar uma gem Faker. Ela vai nos permitir popular nosso banco de dados com informações fictícias...
- vá até o Gemfile na raiz do seu projeto e adicione a dependência no grupo de desenvolvimento


> client-api/Gemfile


```ruby
group :development do
[…]
  gem 'faker'
[…]
end
```

### Feito isso, você já pode instalar as gems do projeto:

```ruby
$ bundle install
```
### Vamos gerar nosso model de clientes.

```ruby
$ rails g model Client name:string phone:string last_purchase:date
```

### Depois disso, confira as credenciais no arquivo de configurações do banco de dados.

> client-api/config/database.yml

```ruby
default: &default
  adapter: postgresql
  encoding: unicode
  username: seu_usuario
  password: sua_senha
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  
development:
  <<: *default
  database: client-api_development
  
test:
  <<: *default
  database: client-api_test

production:
  <<: *default
  database: client-api_production
  username: client-api
  password: <%= ENV['CLIENT-API_DATABASE_PASSWORD'] %>
```

### Agora, pedimos pra que o Rails crie os bancos de dados de desenvolvimento, teste e produção e as tabelas que precisamos.

```ruby
$ rails db:create
$ rails db:migrate
$ rails db:test:prepare
```