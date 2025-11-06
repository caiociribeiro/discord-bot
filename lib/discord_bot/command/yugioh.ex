defmodule DiscordBot.Command.Yugioh do
  alias Nostrum.Api
  alias Yugioh.Client

  def handle_command(msg) do
    case Client.fetch_random() do
      {:ok, image_url} ->
        reply = image_url
        Api.Message.create(msg.channel_id, reply)

      {:error, reason} ->
        Api.Message.create(msg.channel_id, "Erro ao buscar carta: #{reason}")
    end
  end
end
