defmodule VileCards.Core.Player do
  defstruct id: nil, name: nil, score: 0, hand: [], pick: []

  alias __MODULE__

  def new(id, name) do
    %Player{
      id: id,
      name: name
    }
  end
end
