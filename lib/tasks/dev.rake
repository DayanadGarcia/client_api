namespace :dev do
  desc "Configura o db para iniciar o projeto"
  task setup: :environment do
    puts %x(rails db:drop db:create db:migrate db:test:prepare)
  end

end
