defmodule DiscordBot.Command.Shortener do
  alias Nostrum.Api
  alias Shortener.Client

  def handle_command(content, msg) do
    long_url =
      content
      |> String.replace_prefix("!url", "")
      |> String.trim()

    cond do
      long_url == "" ->
        incorrect_format_msg = """
        Formato incorreto.
        Use: `!url <link>`
        Exemplo: `!url https://example.com`
        """
        Api.Message.create(msg.channel_id, incorrect_format_msg)

      true ->
        shorten_and_reply(long_url, msg.channel_id)
    end
  end

  defp shorten_and_reply(long_url, channel_id) do
    case Client.shorten_url(long_url) do
      {:ok, short_url} ->
        msg = """
        URL Encurtada: #{short_url}
        """
        Api.Message.create(channel_id, msg)

      {:error, reason} ->
        Api.Message.create(channel_id, "Não foi possível encurtar a URL.\nMotivo: #{reason}")
    end
  end
end
