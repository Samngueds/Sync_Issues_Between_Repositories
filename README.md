<img align="margin-right: 100px;" src="https://static.wikia.nocookie.net/tibia/images/a/a9/Giant_Ruby.gif/revision/latest?cb=20181107134532&path-prefix=en&format=original" width="60" height="60">[![Typing SVG](https://readme-typing-svg.herokuapp.com?font=Oswald&weight=500&size=30&pause=1000&color=C00F0F&center=true&vCenter=true&width=435&lines=Issue+Sync+Script)](https://git.io/typing-svg)<img align="margin-left: 100px;" src="https://static.wikia.nocookie.net/tibia/images/a/a9/Giant_Ruby.gif/revision/latest?cb=20181107134532&path-prefix=en&format=original" width="60" height="60">

<h2>📑 Issue Sync Script</h2>

Este script Ruby sincroniza issues entre um repositório público e um repositório privado no GitHub. Ele também permite a criação de uma nova issue no repositório privado a partir de um arquivo `issue.md`, se o arquivo estiver presente.

---

### 📊 Funcionalidades

- **Sincronizar Issues**: Sincroniza issues entre um repositório público e um repositório privado, garantindo que as issues do repositório público sejam replicadas no repositório privado e vice-versa.
- **Criar Issue a partir de Arquivo**: Cria uma issue no repositório privado a partir do arquivo `issue.md` se o arquivo existir.
- **Gerar Log de Sincronização**: Cria um log que registra o número de issues em cada repositório e a data e hora da sincronização.

---

## 📜 Instalação

Para usar o script, siga estas etapas:

1. **Configuração dos Tokens e Repositórios**: Certifique-se de definir as variáveis de ambiente `PUBLIC_REPO_TOKEN`, `PRIVATE_REPO_TOKEN`, `PUBLIC_REPO` e `PRIVATE_REPO` com os valores apropriados. Os tokens devem ter permissões adequadas para ler e criar issues.

2. **Instalar Dependências**: Instale a gem `octokit` se ainda não estiver instalada. Você pode adicionar ao seu Gemfile ou instalar diretamente:

    ```bash
    gem install octokit
    ```

---

## 🛠 Uso

1. **Criar o Arquivo `issue.md`**: Se desejar criar uma issue a partir de um arquivo, crie um arquivo `issue.md` no mesmo diretório que o script. O arquivo deve estar no formato:

    ```markdown
    ### Título da Issue
    Corpo da issue.
    ```

2. **Executar o Script**: Execute o script Ruby. Ele criará uma issue no repositório privado se o arquivo `issue.md` existir e sincronizará as issues entre o repositório público e o privado.

    ```bash
    ruby issue_sync_script.rb
    ```

---

## 📋 Exemplo de Log

O script cria um arquivo `issue_sync_log.md` com o seguinte conteúdo:

    Log de Sincronização
    Data e Hora: 2024-09-17 14:45:00
    Issues no Repositório Público: 12
    Issues no Repositório Privado: 15

---

## 🤝 Contribuindo

Contribuições são bem-vindas! Se você tiver sugestões de melhorias ou novas funcionalidades, sinta-se à vontade para abrir uma pull request. Seu feedback e contribuições ajudam a melhorar o script para todos.

---

## 📜 Licença

Este script está disponível sob a [Licença MIT](LICENSE).

---

Para mais informações ou suporte, consulte a documentação do [Octokit](https://octokit.github.io/octokit.rb/) ou entre em contato com o mantenedor do projeto.
