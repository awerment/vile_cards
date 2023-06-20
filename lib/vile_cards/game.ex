defmodule VileCards.Game do
  defstruct players: %{}, black: {}, white: {}, round: 0

  alias VileCards.{Game, Player}

  def new({id, name} = _admin, black, white) do
    %Game{
      players: %{id => Player.new(id, name)},
      black: black,
      white: white
    }
  end
end
