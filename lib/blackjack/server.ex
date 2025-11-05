defmodule Blackjack.Server do
  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def start_game(channel_id, game) do
    Agent.update(__MODULE__, &Map.put(&1, channel_id, game))
  end

  def get_game(channel_id) do
    Agent.get(__MODULE__, &Map.get(&1, channel_id))
  end

  def update_game(channel_id, game) do
    Agent.update(__MODULE__, &Map.put(&1, channel_id, game))
  end

  def end_game(channel_id) do
    Agent.update(__MODULE__, &Map.delete(&1, channel_id))
  end
end
