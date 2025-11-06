defmodule DiscordBot.Command.Lyrics do
  alias Nostrum.Api
  alias Lyrics.Client

  @regex ~r/!lyrics\s+"(.*?)"\s+"(.*?)"$/i

  def handle_command(content, msg) do
    case Regex.run(@regex, content) do
      [_, artist, song] -> fetch_and_reply(artist, song, msg.channel_id)

      nil ->
        incorrect_format_msg = """
        Formato incorreto. Use: `!lyrics \"Artista\" \"Música\"
        Obs: Artista e Musica precisam estar entre aspas.
        """
        Api.Message.create(msg.channel_id, incorrect_format_msg)
    end
  end

  def fetch_and_reply(artist, song, channel_id) do
    case Client.fetch_lyrics(artist, song) do
      {:ok, lyrics} ->
        reply = format_lyrics(lyrics, artist, song)
        Api.Message.create(channel_id, reply)

      _ -> Api.Message.create(channel_id, "Letra nao encontrada ou ocorreu algum erro.")
    end
  end

  defp format_lyrics(lyrics, artist, song) do
    formatted_lyrics =
      if String.length(lyrics) > 1900 do
        "#{String.slice(lyrics, 0, 1900)}...\n\n(Letra muito longa para exibir completamente)"
      else
        lyrics
      end

    """
    🎶 **Letra de "#{song}" por #{artist}**

    #{formatted_lyrics}
    """
  end
end
