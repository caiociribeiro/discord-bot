# DiscordBot

Bot de Discord em Elixir. 

## Instalação

Apos adicionar o bot ao seu servidor ([discord para desenvolvedores](https://discord.com/developers)), siga os passos abaixo para configurar e iniciar o bot:

1. Clone o repositório
2. Instale as dependências:
   ```shell
   mix deps.get
   ```
3. Configure o bot:
    - No powershell, defina a variável de ambiente DISCORD_BOT_TOKEN com o token do seu bot:
      ```shell
      setx DISCORD_BOT_TOKEN "<seu_token_aqui>"
      ```
4. Inicie o bot:
    ```shell
    mix run --no-halt
    ```

## Comandos
- `!blackjack start` - Inicia um novo jogo de Blackjack;
- `!blackjack hit` - Pede uma carta adicional; 
- `!blackjack stand` - Fica com as cartas atuais e encerra o jogo;