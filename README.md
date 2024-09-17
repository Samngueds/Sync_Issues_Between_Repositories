<img align="margin-right: 100px;" src="https://static.wikia.nocookie.net/tibia/images/a/a9/Giant_Ruby.gif/revision/latest?cb=20181107134532&path-prefix=en&format=original" width="60" height="60">[![Typing SVG](https://readme-typing-svg.herokuapp.com?font=Oswald&weight=500&size=30&pause=1000&color=C00F0F&center=true&vCenter=true&width=435&lines=Sync+Issues+between+Repos)](https://git.io/typing-svg)<img align="margin-left: 100px;" src="https://static.wikia.nocookie.net/tibia/images/a/a9/Giant_Ruby.gif/revision/latest?cb=20181107134532&path-prefix=en&format=original" width="60" height="60">

<h2>🔄 Sync Issues Between Repositories</h2>

Este projeto é uma aplicação Ruby para sincronizar issues entre um repositório público e um repositório privado no GitHub. Ele garante que as issues sejam atualizadas em ambos os repositórios, permitindo uma gestão eficiente de problemas.

---

### 📊 Funcionalidades

- **Sincronizar Issues**: Sincroniza issues do repositório público para o privado e vice-versa.
- **Criar Novas Issues**: Permite criar novas issues em um repositório especificado pelo usuário.
- **Configuração Flexível**: Configura repositórios e tokens de acesso através de variáveis de ambiente.

```ruby
require 'octokit'

# Recebe os tokens e nomes dos repositórios do ambiente
public_repo_token = ENV['PUBLIC_REPO_TOKEN']
private_repo_token = ENV['PRIVATE_REPO_TOKEN']
public_repo = ENV['PUBLIC_REPO']     # Nome do repositório público (ex: "usuario/repo_publico")
private_repo = ENV['PRIVATE_REPO']   # Nome do repositório privado (central)

# Configura os clientes Octokit para os repositórios
public_client = Octokit::Client.new(access_token: public_repo_token)
private_client = Octokit::Client.new(access_token: private_repo_token)

def fetch_issues(client, repo)
  puts "Buscando issues do repositório #{repo}..."
  issues = client.issues(repo, state: 'all').map do |issue|
    { number: issue.number, title: issue.title, body: issue.body }
  end
  puts "Issues encontradas: #{issues.size}"
  issues
rescue => e
  puts "Erro ao buscar issues: #{e.message}"
  []
end

def create_issue(client, repo, title, body)
  puts "Criando issue no repositório #{repo}..."
  client.create_issue(repo, title, body)
  puts "Issue criada: #{title}"
rescue => e
  puts "Erro ao criar issue: #{e.message}"
end

def synchronize_issues(source_client, source_repo, target_client, target_repo)
  puts "Sincronizando issues do repositório #{source_repo} para #{target_repo}..."
  source_issues = fetch_issues(source_client, source_repo)
  target_issues = fetch_issues(target_client, target_repo)

  source_issues.each do |issue|
    unless target_issues.any? { |i| i[:title] == issue[:title] }
      create_issue(target_client, target_repo, issue[:title], issue[:body])
    end
  end

  puts "Sincronização concluída entre #{source_repo} e #{target_repo}."
end

puts "Iniciando sincronização de issues..."

# Sincroniza do repositório público para o repositório privado (central)
synchronize_issues(public_client, public_repo, private_client, private_repo)

# Sincroniza do repositório privado (central) para o repositório público
synchronize_issues(private_client, private_repo, public_client, public_repo)
```

- **Descrição**: Este script sincroniza issues entre um repositório público e um privado, garantindo que os problemas sejam atualizados em ambos os lugares.

---

## 📜 Instalação

Para instalar as dependências necessárias, adicione o gem `octokit` e execute:

```sh
gem install octokit
```

---

## 🛠 Uso

Para executar o script, defina as variáveis de ambiente necessárias e execute o comando:

```sh
ruby sync_issues.rb
```

O script perguntará se você deseja criar uma nova issue. Se responder "sim", forneça o título e o corpo da issue, além do nome do repositório e o token correspondente.

---

## 🤝 Contribuições

Contribuições são bem-vindas! Se você tiver sugestões de melhorias ou novos recursos, sinta-se à vontade para enviar um pull request. Seu feedback e contribuições ajudam a melhorar o projeto para todos.

---

## 📜 Licença

Este projeto está disponível sob a [Licença MIT](LICENSE).
