defmodule VileCards.PlayerTest do
  use ExUnit.Case

  alias VileCards.Player

  describe "new/2" do
    test "creates a new player struct with default fields" do
      assert Player.new("id", "name") ==
               %Player{
                 id: "id",
                 name: "name",
                 score: 0,
                 hand: [],
                 pick: [],
                 czar?: false
               }
    end
  end
end
