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

  describe "player_join/2" do
    test "adds a new player" do
      game =
        {"id-1", "name-1"}
        |> Game.new([], [])
        |> Game.player_join({"id-2", "name-2"})

      assert %Game{
               players: %{
                 "id-1" => %Player{id: "id-1", name: "name-1"},
                 "id-2" => %Player{id: "id-2", name: "name-2"}
               }
             } = game
    end

    test "does not add an already existing player (by id)" do
      game =
        {"id", "name"}
        |> Game.new([], [])

      assert %{"id" => %Player{id: "id", name: "name"}} = game.players

      game = game |> Game.player_join({"id", "other name"})

      assert %{"id" => %Player{id: "id", name: "name"}} = game.players
    end
  end

  describe "player_leave/2" do
    test "removes an existing player (by id)" do
      game =
        {"id-1", "name-1"}
        |> Game.new([], [])
        |> Game.player_join({"id-2", "name-2"})
        |> Game.player_leave("id-1")

      assert %{"id-2" => %Player{id: "id-2", name: "name-2"}} = game.players
    end

    test "noop on unknown player id" do
      game =
        {"id-1", "name-1"}
        |> Game.new([], [])
        |> Game.player_leave("unknown")

      assert %{"id-1" => %Player{id: "id-1", name: "name-1"}} = game.players
    end
  end
end
