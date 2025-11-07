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
- Blackjack:
  - `!blackjack start` - Inicia um novo jogo de Blackjack;
  - `!blackjack hit` - Pede uma carta adicional; 
  - `!blackjack stand` - Fica com as cartas atuais e encerra o jogo;

- Lyrics:
  - `!lyrics "<nome do artista>" "<nome da música>"` - Busca a letra da música especificada;

- Exchange:
  - `!exchange <quantia> <moeda de origem> <moeda de destino>` - Converte a quantia especificada da moeda de origem para a moeda de destino;

- Yugioh:
  - `!yugioh` - Busca e exibe uma carta aleatória de Yu-Gi-Oh!.

- URL Shortener:
  - `!url <url>` - Encurta a URL especificada.


## APIs Utilizadas
- [Deck of Cards API](https://deckofcardsapi.com/) - Deck of Cards;
- [Lyrics.ovh API](https://lyricsovh.docs.apiary.io/#) - Simple API to retrieve the lyrics of a song;
- [Currency API](https://github.com/fawazahmed0/exchange-api) - Free Currency Exchange Rates API with 150+ Currencies & No Rate Limits;
- [Yu-Gi-Oh! API](https://db.ygoprodeck.com/api-guide/) - Yu-Gi-Oh! API by YGOPRODeck;
- [URL Shortener API](https://ulvis.net/developer.html) - Free URL shortener offers a powerful API to interact with other sites.

