defmodule DiscordBot.Command.Blackjack do
  alias Nostrum.Api
  alias Blackjack.Game
  alias Blackjack.Server

  def handle_command("start", msg), do: handle_start(msg)
  def handle_command("hit", msg), do: handle_hit(msg)
  def handle_command("stand", msg), do: handle_stand(msg)

  def handle_command(_, msg) do
    Api.Message.create(msg.channel_id, "Use '!blackjack start' para comecar um jogo, '!blackjack hit' para pegar mais uma carta e '!blackjack stand' para segurar.")
  end

  defp handle_start(msg) do
    case Server.get_game(msg.channel_id) do
      %{finished: false} ->
        Api.Message.create(msg.channel_id, "Ja existe um jogo em andamento. Use !blackjack hit ou !blackjack stand.")
        nil -> start_new_game(msg)
        _   -> start_new_game(msg)
    end

  end

  defp start_new_game(msg) do
    case Game.start_game() do
      {:ok, game} ->
        Server.start_game(msg.channel_id, game)
        bot_card = hd(game.bot_cards)
        reply = """
        🃏 Blackjack

        **Sua mao:** #{Game.format_hand(game.player_cards)} **(#{game.player_score})**

        **Eu tenho:** #{Game.format_hand([bot_card])}

        '!blackjack hit' ou '!blackjack stand' para continuar.
        """
        Api.Message.create(msg.channel_id, reply)
    end
  end

  defp handle_hit(msg) do
    case Server.get_game(msg.channel_id) do
      nil -> Api.Message.create(msg.channel_id, "Nenhum jogo foi iniciado. Digite !blackjack start.")

      game ->
        updated_game = Game.hit(game)
        bot_card = hd(updated_game.bot_cards)
        if updated_game.finished do
          Server.end_game(msg.channel_id)
          reply = """
          🃏 Blackjack

          Voce pediu uma carta e estourou! 💥

          **Sua mao:** #{Game.format_hand(updated_game.player_cards)} **(#{updated_game.player_score})**

          Eu venci! Mais sorte na proxima vez. 😅
          """
          Api.Message.create(msg.channel_id, reply)

        else
          Server.update_game(msg.channel_id, updated_game)
          reply = """
          🃏 Blackjack

          Voce pediu uma carta!

          **Sua nova mao:** #{Game.format_hand(updated_game.player_cards)} **(Score: #{updated_game.player_score})**

          **Eu tenho:** #{Game.format_hand([bot_card])}

          '!blackjack hit' ou '!blackjack stand' para continuar.
          """
          Api.Message.create(msg.channel_id, reply)
        end
    end
  end

  defp handle_stand(msg) do
    case Server.get_game(msg.channel_id) do
      nil -> Api.Message.create(msg.channel_id, "Nenhum jogo foi iniciado. Digite !blackjack start.")

      game ->
        Server.end_game(msg.channel_id)

        final_game = Game.stand(game)
        winner = Game.winner(final_game)

        reply = """
        🃏 Blackjack

        Voce parou!

        **Sua mao:** #{Game.format_hand(final_game.player_cards)} **(#{final_game.player_score})**

        **Agora eu tenho:** #{Game.format_hand(final_game.bot_cards)} **(#{final_game.bot_score})**

        **#{winner}**
        """
        Api.Message.create(msg.channel_id, reply)
    end
  end
end
