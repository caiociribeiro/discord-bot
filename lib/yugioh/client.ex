defmodule Yugioh.Client do
  @api "https://db.ygoprodeck.com/api/v7/cardinfo.php?num=1&offset=0&sort=random&cachebust"

  def fetch_random do
    url = @api
    request = Finch.build(:get, url)

    case Finch.request(request, MyFinch) do
      {:ok, %{status: 200, body: body}} ->
        parse_card_data(body)

      {:ok, %{status: status}} ->
        {:error, "API de Yu-Gi-Oh! retornou um status inesperado: #{status}"}

      {:error, reason} ->
        {:error, "Erro de rede: #{inspect(reason)}"}
    end
  end

  defp parse_card_data(body) do
    data = JSON.decode!(body)

    case get_in(data, ["data", Access.at(0), "card_images", Access.at(0), "image_url"]) do
      nil -> {:error, "API não retornou um URL de imagem no formato esperado."}
      image_url -> {:ok, image_url}
    end
  end

end
