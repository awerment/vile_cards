defmodule VileCards.GameTest do
  use ExUnit.Case

  alias VileCards.{Game, Player}

  describe "new/3" do
    test "creates a new Game struct with default fields" do
      assert Game.new({"id", "name"}, ["a black card"], ["a white card"]) ==
               %Game{
                 players: %{"id" => %Player{id: "id", name: "name"}},
                 black: {["a black card"], []},
                 white: {["a white card"], []},
                 round: 0,
                 card: nil
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

  describe "deal/1" do
    test "deals white cards to players' hands" do
      game =
        {"id-1", "name-1"}
        |> Game.new(Enum.to_list(1..10), Enum.to_list(1..100))
        |> Game.player_join({"id-2", "name-2"})

      assert %{"id-1" => %Player{hand: []}, "id-2" => %Player{hand: []}} = game.players

      %Game{white: {draw, []}, players: players} = Game.deal(game)

      assert %{"id-1" => %Player{hand: id_1_hand}, "id-2" => %Player{hand: id_2_hand}} = players
      assert Enum.count(id_1_hand) == 10
      assert Enum.count(id_2_hand) == 10
      assert Enum.count(draw) == 80
      assert MapSet.disjoint?(MapSet.new(id_1_hand), MapSet.new(id_2_hand))
      assert MapSet.disjoint?(MapSet.new(id_1_hand ++ id_2_hand), MapSet.new(draw))
    end
  end

  describe "start_round/1" do
    test "starts a new round" do
      game =
        {"id-1", "name-1"}
        |> Game.new(Enum.to_list(1..10), Enum.to_list(1..100))
        |> Game.player_join({"id-2", "name-2"})
        |> Game.player_join({"id-3", "name-3"})

      assert %Game{round: 0, card: nil} = game

      game = Game.start_round(game)

      assert %Game{round: 1, card: card, black: {draw, []}} = game
      assert card in Enum.to_list(1..10)
      refute card in draw
    end
  end
end
