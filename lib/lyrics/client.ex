defmodule Lyrics.Client do
  def fetch_lyrics(artist, song) do
    artist_encoded = URI.encode_www_form(artist)
    song_encoded = URI.encode_www_form(song)
    url = "https://api.lyrics.ovh/v1/#{artist_encoded}/#{song_encoded}"

    request = Finch.build(:get, url)

    case Finch.request(request, MyFinch) do
      {:ok, %{status: 200, body: body}} ->
        data = JSON.decode!(body)
        lyrics = data["lyrics"]
        lyrics = String.replace(lyrics, "\r\n", "\n")
        lyrics = Regex.replace(~r/\n{3,}/, lyrics, "\n\n")
        {:ok, lyrics}

      {:ok, %{status: 404}} -> {:error, :not_found}

      {:error, reason} -> {:error, reason}
    end
  end
end
