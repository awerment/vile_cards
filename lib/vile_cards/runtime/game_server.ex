defmodule VileCards.Runtime.GameServer do
  use GenServer

  # Client API

  def start_link(game_id, {id, name}, black, white) do
    GenServer.start_link(__MODULE__, {game_id, {id, name}, black, white})
  end

  def player_join(server, {id, name}) do
    GenServer.call(server, {:player_join, {id, name}})
  end

  def player_leave(server, id) do
    GenServer.call(server, {:player_leave, id})
  end

  def start_round(server) do
    GenServer.call(server, :start_round)
  end

  def player_pick(server, player_id, pick) do
    GenServer.call(server, {:player_pick, player_id, pick})
  end

  def force_picks(server) do
    GenServer.call(server, :force_picks)
  end

  def czar_pick(server, player_id) do
    GenServer.call(server, {:czar_pick, player_id})
  end

  def force_czar_pick(server) do
    GenServer.call(server, :force_czar_pick)
  end

  # GenServer Callbacks

  def init({game_id, {id, name}, black, white}) do
    {:ok, impl().new(game_id, {id, name}, black, white)}
  end

  def handle_call({:player_join, {id, name}}, _from, game) do
    updated_game = impl().player_join(game, {id, name})
    {:reply, updated_game, updated_game}
  end

  def handle_call({:player_leave, id}, _from, game) do
    updated_game = impl().player_leave(game, id)
    {:reply, updated_game, updated_game}
  end

  def handle_call(:start_round, _from, game) do
    updated_game = impl().start_round(game)
    {:reply, updated_game, updated_game}
  end

  def handle_call({:player_pick, player_id, pick}, _from, game) do
    updated_game = impl().player_pick(game, player_id, pick)
    {:reply, updated_game, updated_game}
  end

  def handle_call(:force_picks, _from, game) do
    updated_game = impl().force_picks(game)
    {:reply, updated_game, updated_game}
  end

  def handle_call({:czar_pick, player_id}, _from, game) do
    updated_game = impl().czar_pick(game, player_id)
    {:reply, updated_game, updated_game}
  end

  def handle_call(:force_czar_pick, _from, game) do
    updated_game = impl().force_czar_pick(game)
    {:reply, updated_game, updated_game}
  end

  defp impl(), do: Application.get_env(:vile_cards, :core, VileCards.Core.Game)
end
