defmodule Blackjack.Game do
  @api "https://deckofcardsapi.com/api/deck"

  defp new_deck do
    url = "#{@api}/new/shuffle/?deck_count=1"
    request = Finch.build(:get, url)

    case Finch.request(request, MyFinch) do
      {:ok, %{status: 200, body: body}} ->
        deck = JSON.decode!(body)
        {:ok, deck["deck_id"]}
      {:error, reason} -> {:error, reason}
    end
  end

  defp draw_cards(deck_id, count) do
    url = "#{@api}/#{deck_id}/draw/?count=#{count}"
    request = Finch.build(:get, url)

    case Finch.request(request, MyFinch) do
      {:ok, %{status: 200, body: body}} ->
        data = JSON.decode!(body)
        {:ok, data["cards"]}
      {:error, reason} -> {:error, reason}
    end
  end

  def start_game do
    with {:ok, deck_id} = new_deck(),
         {:ok, player_cards} = draw_cards(deck_id, 2),
         {:ok, bot_cards} = draw_cards(deck_id, 2) do

      game = %{
          deck_id: deck_id,
          player_cards: player_cards,
          bot_cards: bot_cards,
          player_score: calculate_score(player_cards),
          bot_score: calculate_score(bot_cards),
          finished: false
          }
      {:ok, game}
    end
  end

  @doc """
  Player recebe uma nova carta
  """
  def hit(game) do
    with {:ok, [new_card]} <- draw_cards(game.deck_id, 1) do
      new_cards = [new_card | game.player_cards]
      new_score = calculate_score(new_cards)
      finished = new_score > 21

      %{game | player_cards: new_cards, player_score: new_score, finished: finished}
    end
  end

  @doc """
  Player decide parar. Bot faz sua acao
  """
  def stand(game) do
    new_bot_cards = run_bot_turn(game.bot_cards, game.deck_id)

    %{game | bot_cards: new_bot_cards, bot_score: calculate_score(new_bot_cards), finished: true}
  end

  def calculate_score(cards) do
    values = Enum.map(cards, &card_value/1)
    base_score = Enum.sum(values)
    aces = Enum.count(values, &(&1 == 11))

    adjust_for_aces(base_score, aces)
  end

  defp card_value(%{"value" => "ACE"}), do: 11
  defp card_value(%{"value" => "KING"}), do: 10
  defp card_value(%{"value" => "QUEEN"}), do: 10
  defp card_value(%{"value" => "JACK"}), do: 10
  defp card_value(%{"value" => value}), do: String.to_integer(value)

  defp adjust_for_aces(score, 0), do: score
  defp adjust_for_aces(score, _aces) when score <= 21, do: score
  defp adjust_for_aces(score, aces) when score > 21 and aces > 0 do
    adjust_for_aces(score - 10, aces - 1)
  end

  defp run_bot_turn(cards, deck_id) do
    score = calculate_score(cards)

    if score < 17 do
      {:ok, [new_card]} = draw_cards(deck_id, 1)
      run_bot_turn([new_card | cards], deck_id)
    else
      cards
    end
  end

  def winner(game) do
    player = game.player_score
    bot = game.bot_score

    cond do
      bot > 21 -> "Eu estourei! Voce venceu! Parabens 🎉 "
      player > bot -> "Voce venceu! Parabens 🎉"
      bot > player -> "Eu venci! Mais sorte na proxima vez. 😅"
      true -> "Empate. Que sem graca. 💩"
    end
  end

  def format_hand(cards) do
    Enum.map(cards, fn card ->
      value = format_card_value(card["value"])
      suit = format_card_suit(card["suit"])
      "#{value} #{suit}"
    end)
    |> Enum.join(" ")
  end

  defp format_card_value(value) do
    case value do
    "ACE" -> "A"
    "KING" -> "K"
    "QUEEN" -> "Q"
    "JACK" -> "J"
    value -> value
  end
  end

  defp format_card_suit(suit) do
    case suit do
      "SPADES" -> "♠️"
      "HEARTS" -> "♥️"
      "DIAMONDS" -> "♦️"
      "CLUBS" -> "♣️"
      _ -> ""
    end
  end
end
