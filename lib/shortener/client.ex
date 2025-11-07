defmodule Shortener.Client do
  @api "https://ulvis.net/api.php"

  def shorten_url(long_url) do
    url_encoded = URI.encode_www_form(long_url)
    url = "#{@api}?url=#{url_encoded}"

    request = Finch.build(:get, url)

    case Finch.request(request, MyFinch) do
      {:ok, %{status: 200, body: body}} ->
        parse_response(body)

      {:ok, %{status: _status}} ->
        {:error, "Ha algum problema com a API no momento."}

      {:error, reason} ->
        {:error, "Erro de rede: #{inspect(reason)}"}
    end
  end

  defp parse_response(body) do
    trimmed = String.trim(body)

    cond do
      String.starts_with?(trimmed, "https://") or String.starts_with?(trimmed, "http://") ->
        {:ok, trimmed}

      true ->
        {:ok, "Api retornou algo inesperado."}
    end
  end
end
