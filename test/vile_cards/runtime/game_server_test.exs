defmodule VileCards.Runtime.GameServerTest do
  use ExUnit.Case, async: false
  import Mox
  alias VileCards.Runtime.GameServer
  alias VileCards.Core.GameMock

  setup :set_mox_global
  setup :verify_on_exit!

  @deck {[], []}
  setup context do
    if Map.get(context, :game, false) do
      expect(GameMock, :new, fn {"id-1", "name-1"}, _black, _white -> :ok end)

      {:ok, game} = GameServer.start_link({"id-1", "name-1"}, @deck, @deck)
      {:ok, game: game}
    else
      :ok
    end
  end

  test "start_link/3 calls Game.new/3" do
    expect(GameMock, :new, fn {"id", "name"}, _black, _white -> :ok end)

    assert {:ok, _pid} = GameServer.start_link({"id", "name"}, {[], []}, {[], []})
  end

  @tag :game
  test "player_join/2 calls Game.player_join/2", %{game: game} do
    expect(GameMock, :player_join, fn _game, {"id-2", "name-2"} -> :ok end)

    GameServer.player_join(game, {"id-2", "name-2"})
  end

  @tag :game
  test "player_leave/2 calls Game.player_leave/2", %{game: game} do
    expect(GameMock, :player_leave, fn _game, "id-1" -> :ok end)

    GameServer.player_leave(game, "id-1")
  end

  @tag :game
  test "start_round/1 calls Game.start_round/1", %{game: game} do
    expect(GameMock, :start_round, fn _game -> :ok end)

    GameServer.start_round(game)
  end

  @tag :game
  test "player_pick/3 calls Game.player_pick/3", %{game: game} do
    expect(GameMock, :player_pick, fn _game, _player, _pick -> :ok end)

    GameServer.player_pick(game, "id-1", [])
  end

  @tag :game
  test "force_picks/1 calls Game.force_picks/1", %{game: game} do
    expect(GameMock, :force_picks, fn _game -> :ok end)

    GameServer.force_picks(game)
  end

  @tag :game
  test "czar_pick/2 calls Game.czar_pick/2", %{game: game} do
    expect(GameMock, :czar_pick, fn _game, _player_id -> :ok end)

    GameServer.czar_pick(game, "id-1")
  end

  @tag :game
  test "force_czar_pick/1 calls Game.force_czar_pick/1", %{game: game} do
    expect(GameMock, :force_czar_pick, fn _game -> :ok end)

    GameServer.force_czar_pick(game)
  end
end
