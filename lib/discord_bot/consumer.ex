defmodule DiscordBot.Consumer do
  use Nostrum.Consumer

  alias Nostrum.Api
  alias DiscordBot.Command.Blackjack
  alias DiscordBot.Command.Lyrics
  alias DiscordBot.Command.Exchange

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    case msg.content do
      "!ping" ->
        Api.Message.create(msg.channel_id, "pong!")
      _ ->
        dispatch_command(msg.content, msg)
    end
  end

  # Default handler for all other events
  def handle_event(_event) do
    :noop
  end

  defp dispatch_command(content, msg) do
    cond do
      String.starts_with?(content, "!blackjack") ->
        parts = String.split(content)
        sub_command = Enum.at(parts, 1)
        Blackjack.handle_command(sub_command, msg)

      String.starts_with?(content, "!lyrics") ->
        Lyrics.handle_command(content, msg)

       String.starts_with?(content, "!exchange") ->
        Exchange.handle_command(content, msg)

      true -> :ignore
    end
  end

end
