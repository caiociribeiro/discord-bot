defmodule DiscordBot.Command.Exchange do
  alias Nostrum.Api
  alias Exchange.Client

  @regex ~r/!exchange\s+(\d+\.?\d*)\s+([a-z]{3})\s+([a-z]{3})$/i

  def handle_command(content, msg) do
    case Regex.run(@regex, content) do
      [_, value_str, from_cur, to_cur] ->
        value = elem(Float.parse(value_str), 0)
        from = String.downcase(from_cur)
        to = String.downcase(to_cur)
        fetch_and_reply(value, from, to, msg.channel_id)

      nil ->
        incorrect_format_msg = """
        Formato incorreto.
        Use: '!exchange <valor> <moeda_origem> <moeda_destino>'. Ex: '!exchange 100 brl usd'
        !exchange para exibir a lista de moedas
        """
        Api.Message.create(msg.channel_id, incorrect_format_msg)
    end
  end

  defp fetch_and_reply(value, from, to, channel_id) do
    case Client.get_rate(from, to) do
      {:ok, rate} ->
        exchanged_value = value * rate
        reply = format_response(value, from, exchanged_value, to)
        Api.Message.create(channel_id, reply)

      {:error, reason} ->
        Api.Message.create(channel_id, "#{reason}")
    end
  end

  defp format_response(value, from, exchanged_value, to) do
    from = String.upcase(from)
    to = String.upcase(to)

    value = :erlang.float_to_list(value, decimals: 2)
    exchanged_value = :erlang.float_to_list(exchanged_value, decimals: 2)

    """
    **#{value} #{from}** = **#{exchanged_value} #{to}**
    """
  end
end
