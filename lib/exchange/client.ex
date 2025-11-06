defmodule Exchange.Client do
  @api "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies"

  def get_rate(from, to) do
    from = String.downcase(from)
    to = String.downcase(to)

    url = "#{@api}/#{from}.json"

    request = Finch.build(:get, url)

    case Finch.request(request, MyFinch) do
      {:ok, %{status: 200, body: body}} ->
        data = JSON.decode!(body)
        case Map.get(data, from) do
          nil ->
            {:error, "Algo deu errado. Tente novamente."}

          exchange_rates ->
            case Map.get(exchange_rates, to) do
              nil ->
                {:error, "Moeda de destino **#{String.upcase(from)}** não encontrada."}
              rate ->
                {:ok, rate}
            end
        end

        {:ok, %{status: 404}} ->
          {:error, "Moeda de origem **#{String.upcase(to)}** nao encontrada."}


        {:error, reason} ->
          {:error, "Erro de rede: #{inspect(reason)}"}
    end
  end
end
