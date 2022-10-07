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

#### OU


### Criamos uma **rake task** para executar de forma simples os comandos de criação, migração e população do banco de dados, com o seguinte comando:

```ruby
rails g task dev setup
```
- Esse comando vai gerar uma arquivo dev.rake, que contém os seguintes trecho:

> lib/tasks/dev.rake

```ruby
namespace :dev do
  desc "TODO"
  task setup: :environment do
  end

end
```
- vamos fazer uma alteração para que ao rodar nosso rake task ele gere o nosso banco:

```ruby
namespace :dev do
  desc "Configura o db para iniciar o projeto"
  task setup: :environment do
    puts %x(rails db:drop db:create db:migrate db:test:prepare)
  end

end
```
- agora podemos usar o rake task com o simples comando:

```ruby
rails dev:setup
```

### Com a tabela criada, vamos tratar algumas validações nos nossos campos do cliente, pra impedir que alguém mande informações erradas...

> client-api/app/models/client.rb

```ruby
class Client < ApplicationRecord
    validates :name, presence: true
    validates :phone, presence: true
    validates :last_purchase, presence: true
end
```

### Agora que temos nosso model e banco configurados, vamos popular nosso banco com dados gerados pela Faker que adicionamos lá atrás.

> client-api/db/seeds.rb

```ruby
50.times  do
	Client.create({
		name: Faker::Name.name,
        phone: Faker::PhoneNumber.cell_phone,
        last_purchase: Faker::Date.between(from: 30.days.ago, to: Date.today)
	})
end
```

- E para adicionar esses dados no ambiente de desenvolvimento apenas, execute o seguinte comando no terminal:

```ruby
$ rails db:seed RAILS_ENV=development
```

### Agora que já temos o model configurado e um banco de dados com informações, podemos começar a desenvolver os métodos básicos da nossa API.

#### Vamos criar os diretórios **v1/api/** em **client-api/app/controllers** e lá dentro, um arquivo chamado **clients_controller.rb** onde vamos criar os módulos **Api** e **v1** e a classe que servirá de controller dos clientes.

- E nessa mesma classe, um método index que retorne todos os nossos clientes ordenando pela data da última compra.
- Adicionando também os métodos show, create, update e destroy, o código fica assim:

> client-api/app/controller/api/v1/clients_controller.rb

```ruby
module Api
	module V1
		class ClientsController < ApplicationController   
		    def index
          client = Client.order('last_purchase');
          render json: {status: 'SUCCESS', message: 'Client list.', data:client}, status: :ok
		    end

		    def show
          client = Client.find(params[:id])
          render json: {status: 'SUCCESS', message: 'Client founded.', data:client}, status: :ok
		    end

		    def create
          client = Client.new(client_params)
          if client.save
			      render json: {status: 'SUCCESS', message: 'Client added.', data:client}, status: :ok
			    else
			      render json: {status: 'ERROR', message: 'Can not add the client.', data:client.err}, status: :unprocessable_entity
			    end
		    end

		    def update
          client = Client.find(params[:id])
          if client.update(client_params)
			      render json: {status: 'SUCCESS', message: 'Client updated.', data:client}, status: :ok
			    else
			      render json: {status: 'ERROR', message: 'Can not update client.', data:client}, status: :unprocessable_entity
			    end
		    end

		    def destroy
          client = Client.find(params[:id])
          client.destroy
			    render json: {status: 'SUCCESS', message: 'Client deleted.', data:client}, status: :ok
		    end

		    private
		    def client_params
			    params.permit(:name, :phone, :last_purchase)
		    end
		end
	end
end
```

### Antes de testar, precisamos definir as rotas da nossa api. Para isso, altere o arquivo de configurações das rotas:

> client-api/config/routes.rb

```ruby
Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :clients
    end
  end
end
```
- Você pode visualizar as rotas da sua aplicação com o comando:

```ruby
 $ rails routes
```

### Ok. Tudo pronto pra testar nossa api. Para isso, inicie o servidor:

```ruby
 $ rails s
```
### Para testar os métodos, podemos usar o Insomnia

  - Listando todos clientes (método index):


 ![lista de clintes](/images/Captura%20de%20tela%20de%202022-10-07%2018-26-16.png)


  - Pesquisando cliente pelo id (método show):


  ![busca pelo id do cliente](/images/Captura%20de%20tela%20de%202022-10-07%2018-30-57.png)


  - Cadastrando um novo cliente (método create):


  ![busca pelo id do cliente](/images/Captura%20de%20tela%20de%202022-10-07%2018-33-37.png)


  - Atualizando um cliente (método update):


  ![busca pelo id do cliente](/images/Captura%20de%20tela%20de%202022-10-07%2018-50-32.png)


  - Deletar um cliente (método delete):


  ![busca pelo id do cliente](/images/Captura%20de%20tela%20de%202022-10-07%2018-54-20.png)


### Utilizamos nesse projeto as gem **Faker** e **PG** para gerar dados fictícios e conectar com o banco de dados, respectivamente, e assim concluímos nossa API Rest em Rails!






