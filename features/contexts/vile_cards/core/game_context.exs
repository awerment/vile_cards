defmodule VileCards.Core.GameContext do
  use WhiteBread.Context

  alias VileCards.Core.{Game, Player}

  feature_starting_state fn  -> %{} end
  scenario_starting_state fn state -> state end
  scenario_finalize fn _status, state -> state end

  @game_admin {"admin-id", "admin-name"}
  @game_id "game-0001"
  @dummy_black_cards 1..100
  @dummy_white_cards 1..1000

  given_ ~r/^a new game$/, fn state ->
    {:ok, Map.put(state, :game, Game.new(@game_id, @game_admin, @dummy_black_cards, @dummy_white_cards))}
  end

  when_ ~r/^a player with id "(?<id>[^"]+)" and name "(?<name>[^"]+)" joins$/,
    fn state, %{id: id, name: name} ->
      {:ok, Map.replace_lazy(state, :game, fn game -> Game.player_join(game, {id, name}) end)}
    end

  when_ ~r/^a player with id "(?<id>[^"]+)" leaves$/,
    fn state, %{id: id} ->
      {:ok, Map.replace_lazy(state, :game, fn game -> Game.player_leave(game, id) end)}
    end

  then_ ~r/^a player with id "(?<id>[^"]+)" and name "(?<name>[^"]+)" exists$/,
    fn %{game: game} = state, %{id: id, name: name} ->
      assert Map.has_key?(game.players, id)
      assert %Player{name: ^name} = Map.get(game.players, id)
      {:ok, state}
    end

  then_ ~r/^no player with id "(?<id>[^"]+)" exists$/,
    fn %{game: game} = state, %{id: id} ->
      refute Map.has_key?(game.players, id)
      {:ok, state}
    end

  then_ ~r/^the player with id "(?<id>[^"]+)" has score (?<score>[0-9]+)$/,
    fn %{game: game} = state, %{id: id, score: score} ->
      {score, ""} = Integer.parse(score)
      assert %Player{score: ^score} =  Map.get(game.players, id)
      {:ok, state}
    end

  then_ ~r/^the player with id "(?<id>[^"]+)" has empty hand$/,
    fn %{game: game} = state, %{id: id} ->
      assert %Player{hand: []} =  Map.get(game.players, id)
      {:ok, state}
    end

  then_ ~r/^the player with id "(?<id>[^"]+)" has empty pick$/,
    fn %{game: game} = state, %{id: id} ->
      assert %Player{pick: []} =  Map.get(game.players, id)
      {:ok, state}
    end
end
