defmodule VileCards do
  @moduledoc """
  TODO
  """
  alias VileCards.Runtime.{GameRegistry, GameServer, GameSupervisor}

  def start_game(id, admin, black, white) do
    DynamicSupervisor.start_child(GameSupervisor, {GameServer, [id, admin, black, white]})
  end

  def stop_game(pid) do
    DynamicSupervisor.terminate_child(GameSupervisor, pid)
  end

  def game_via(id) do
    {:via, Registry, {GameRegistry, id}}
  end
end
