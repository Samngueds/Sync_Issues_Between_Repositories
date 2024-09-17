require 'octokit'
require 'fileutils'
require 'date'

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

def create_issue_from_file(file_path, repo, token)
  if File.exist?(file_path)
    puts "Arquivo de issue encontrado: #{file_path}"
    title, body = parse_issue_file(file_path)
    client = Octokit::Client.new(access_token: token)
    create_issue(client, repo, title, body)
  else
    puts "Arquivo de issue não encontrado. Somente sincronização será realizada."
  end
end

def parse_issue_file(file_path)
  title = nil
  body = nil
  File.open(file_path, 'r') do |file|
    lines = file.readlines
    if lines.any?
      title_line = lines.find { |line| line.start_with?('### ') }
      title = title_line ? title_line.sub('### ', '').strip : 'Sem título'
      body = lines[lines.index(title_line) + 1..-1].join.strip if title_line
    end
  end
  [title, body]
end

def write_log(issues_count_public, issues_count_private)
  timestamp = DateTime.now.strftime('%Y-%m-%d %H:%M:%S')
  log_content = <<~LOG
    Log de Sincronização
    Data e Hora: #{timestamp}
    Issues no Repositório Público: #{issues_count_public}
    Issues no Repositório Privado: #{issues_count_private}
  LOG

  File.open('issue_sync_log.md', 'w') do |file|
    file.write(log_content)
  end

  puts "Log de sincronização criado."
end

puts "Iniciando sincronização de issues..."

# Caminho para o arquivo de issue
issue_file_path = 'issue.md'

# Cria a issue no repositório privado se o arquivo de issue existir
create_issue_from_file(issue_file_path, private_repo, private_repo_token)

# Sincroniza do repositório público para o repositório privado (central)
public_issues = fetch_issues(public_client, public_repo)
private_issues = fetch_issues(private_client, private_repo)
synchronize_issues(public_client, public_repo, private_client, private_repo)

# Sincroniza do repositório privado (central) para o repositório público
synchronize_issues(private_client, private_repo, public_client, public_repo)

# Cria o log de sincronização
write_log(public_issues.size, private_issues.size)
