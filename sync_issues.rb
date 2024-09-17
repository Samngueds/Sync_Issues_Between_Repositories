require 'octokit'

# Recebe os tokens e nomes dos repositórios do ambiente
public_repo_token = ENV['PUBLIC_REPO_TOKEN']
private_repo_token = ENV['PRIVATE_REPO_TOKEN']
central_repo_token = ENV['CENTRAL_REPO_TOKEN']  # Token do repositório central de issues
public_repo = ENV['PUBLIC_REPO']
private_repo = ENV['PRIVATE_REPO']
central_repo = ENV['CENTRAL_REPO']  # Nome do repositório central de issues

# Configura os clientes Octokit para os repositórios
public_client = Octokit::Client.new(access_token: public_repo_token)
private_client = Octokit::Client.new(access_token: private_repo_token)
central_client = Octokit::Client.new(access_token: central_repo_token)

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
    if target_issues.any? { |i| i[:title] == issue[:title] }
      puts "Issue '#{issue[:title]}' já existe no repositório de destino. Pulando..."
    else
      create_issue(target_client, target_repo, issue[:title], issue[:body])
    end
  end

  puts "Sincronização concluída entre #{source_repo} e #{target_repo}."
end

puts "Iniciando sincronização de issues..."

# Sincroniza do repositório público para o repositório central
synchronize_issues(public_client, public_repo, central_client, central_repo)

# Sincroniza do repositório privado para o repositório central
synchronize_issues(private_client, private_repo, central_client, central_repo)

# Sincroniza do repositório central para o repositório público
synchronize_issues(central_client, central_repo, public_client, public_repo)

# Sincroniza do repositório central para o repositório privado
synchronize_issues(central_client, central_repo, private_client, private_repo)
