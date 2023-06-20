defmodule VileCards.Game do
  defstruct players: %{}, black: {[], []}, white: {[], []}, round: 0

  alias VileCards.{Game, Player}

  def new({id, name} = _admin, black, white) do
    %Game{
      players: %{id => Player.new(id, name)},
      black: {black, []},
      white: {white, []}
    }
  end

  def player_join(%Game{} = game, {id, name}) do
    Map.replace_lazy(game, :players, fn players ->
      Map.put_new(players, id, Player.new(id, name))
    end)
  end

  def player_leave(%Game{} = game, id) do
    Map.replace_lazy(game, :players, fn players ->
      Map.delete(players, id)
    end)
  end
end
