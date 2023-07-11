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

  given_ ~r/^an empty state$/, fn state -> {:ok, state} end

  given_ ~r/^a new game$/, fn state ->
    {:ok, Map.put(state, :game, Game.new(@game_id, @game_admin, @dummy_black_cards, @dummy_white_cards))}
  end

  when_ ~r/^a new game is started$/, fn state, %{table_data: [params]} ->
    black_cards = params[:black_cards] |> String.split(",", trim: true) |> Enum.map(&String.trim/1)
    white_cards = params[:white_cards] |> String.split(",", trim: true) |> Enum.map(&String.trim/1)
    game = Game.new(params[:game_id], {params[:admin_id], params[:admin_name]}, black_cards, white_cards)

    {:ok, Map.put(state, :game, game)}
  end

  when_ ~r/^a player with id "(?<id>[^"]+)" and name "(?<name>[^"]+)" joins$/,
    fn state, %{id: id, name: name} ->
      {:ok, Map.replace_lazy(state, :game, fn game -> Game.player_join(game, {id, name}) end)}
    end

  when_ ~r/^a player with id "(?<id>[^"]+)" leaves$/,
    fn state, %{id: id} ->
      {:ok, Map.replace_lazy(state, :game, fn game -> Game.player_leave(game, id) end)}
    end

  then_ ~r/^a new game with id "(?<game_id>[^"]+)" exists$/, fn state, %{game_id: game_id} ->
    assert %Game{id: ^game_id} = state.game
    {:ok, state}
  end

  then_ ~r/^the deck has (?<black_cards>[0-9]+) black cards on the draw pile$/, fn state, %{black_cards: black_cards} ->
    {black_cards, ""} = Integer.parse(black_cards)
    assert %Game{black: {draw, _discard}} = state.game
    assert Enum.count(draw) == black_cards
    {:ok, state}
  end

  then_ ~r/^the deck has (?<black_cards>[0-9]+) black cards on the discard pile$/, fn state, %{black_cards: black_cards} ->
    {black_cards, ""} = Integer.parse(black_cards)
    assert %Game{black: {_draw, discard}} = state.game
    assert Enum.count(discard) == black_cards
    {:ok, state}
  end

  then_ ~r/^the deck has (?<white_cards>[0-9]+) white cards on the draw pile$/, fn state, %{white_cards: white_cards} ->
    {white_cards, ""} = Integer.parse(white_cards)
    assert %Game{white: {draw, [] = _discard}} = state.game
    assert Enum.count(draw) == white_cards
    {:ok, state}
  end

  then_ ~r/^the deck has (?<white_cards>[0-9]+) white cards on the discard pile$/, fn state, %{white_cards: white_cards} ->
    {white_cards, ""} = Integer.parse(white_cards)
    assert %Game{white: {_draw, discard}} = state.game
    assert Enum.count(discard) == white_cards
    {:ok, state}
  end

  then_ ~r/^the game round is (?<round>[0-9]+)$/, fn state, %{round: round} ->
    {round, ""} = Integer.parse(round)
    assert %Game{round: ^round} = state.game
    {:ok, state}
  end

  then_ ~r/^no czar is picked$/, fn state ->
    assert %Game{czar: nil} = state.game
    {:ok, state}
  end

  then_ ~r/^no black card is drawn$/, fn state ->
    assert %Game{card: nil} = state.game
    {:ok, state}
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
