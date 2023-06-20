defmodule VileCards.GameTest do
  use ExUnit.Case

  alias VileCards.{Game, Player}

  describe "new/3" do
    test "creates a new Game struct with default fields" do
      assert Game.new({"id", "name"}, ["a black card"], ["a white card"]) ==
               %Game{
                 players: %{"id" => %Player{id: "id", name: "name"}},
                 black: ["a black card"],
                 white: ["a white card"],
                 round: 0
               }
    end
  end
end
