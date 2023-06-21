defmodule VileCards.Core.Game do
  defstruct players: %{}, black: {[], []}, white: {[], []}, round: 0, card: nil, czar: nil

  alias VileCards.Core.{Deck, Game, Player}

  def new({id, name} = _admin, black, white) do
    %Game{
      players: %{id => Player.new(id, name)},
      black: {Enum.shuffle(black), []},
      white: {Enum.shuffle(white), []}
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

  @hand_count 10
  def deal(%Game{white: white, players: players} = game) do
    {updated_white, updated_players} =
      players
      |> Enum.reduce({white, players}, fn {id, player}, {deck, players} ->
        {deck, drawn} = Deck.draw(deck, @hand_count - Enum.count(player.hand))

        {deck,
         Map.replace_lazy(players, id, fn player ->
           Map.replace_lazy(player, :hand, fn hand -> hand ++ drawn end)
         end)}
      end)

    %Game{game | white: updated_white, players: updated_players}
  end

  def start_round(%Game{round: round} = game) do
    %Game{game | round: round + 1}
    |> discard_picks()
    |> discard_black()
    |> pick_czar()
    |> draw_black()
    |> deal()
  end

  def player_pick(%Game{players: players} = game, player_id, pick) do
    updated_players =
      Map.replace_lazy(players, player_id, fn %Player{hand: hand} = player ->
        player
        |> Map.replace(:pick, pick)
        |> Map.replace(:hand, hand -- pick)
      end)

    %Game{game | players: updated_players}
  end

  def force_picks(%Game{players: players, card: %{pick: pick}, czar: czar} = game) do
    players
    |> Enum.filter(fn {id, player} -> player.pick == [] and id != czar end)
    |> Enum.reduce(game, fn {id, %Player{hand: hand}}, game ->
      player_pick(game, id, Enum.shuffle(hand) |> Enum.take(pick))
    end)
  end

  def czar_pick(%Game{players: players} = game, player_id) do
    updated_players =
      Map.replace_lazy(players, player_id, fn player ->
        Map.replace_lazy(player, :score, fn score -> score + 1 end)
      end)

    %Game{game | players: updated_players}
  end

  def force_czar_pick(%Game{players: players, czar: czar} = game) do
    {id, _player} =
      players
      |> Enum.filter(fn {id, _player} -> id != czar end)
      |> Enum.random()

    czar_pick(game, id)
  end

  defp discard_picks(%Game{players: players, white: white} = game) do
    {updated_white, updated_players} =
      players
      |> Enum.reduce({white, players}, fn {id, player}, {deck, players} ->
        deck = Deck.discard(deck, player.pick)

        {deck,
         Map.replace_lazy(players, id, fn player ->
           Map.replace(player, :pick, [])
         end)}
      end)

    %Game{game | white: updated_white, players: updated_players}
  end

  defp pick_czar(%Game{players: players} = game) when map_size(players) == 0 do
    %Game{game | czar: nil}
  end

  defp pick_czar(%Game{players: players, czar: nil} = game) do
    %Game{game | czar: Enum.random(players) |> elem(0)}
  end

  defp pick_czar(%Game{players: players} = game) when map_size(players) == 1 do
    %Game{game | czar: Enum.at(players, 0) |> elem(0)}
  end

  defp pick_czar(%Game{players: players, czar: czar} = game) do
    new_czar =
      players
      |> Enum.map(fn {id, _player} -> id end)
      |> then(fn ids -> MapSet.new([czar | ids]) end)
      |> Enum.sort()
      |> Stream.cycle()
      |> Stream.drop_while(fn id -> id != czar end)
      |> Stream.drop(1)
      |> Enum.at(0)

    %Game{game | czar: new_czar}
  end

  defp draw_black(%Game{black: black} = game) do
    {black, [card]} = Deck.draw(black, 1)
    %Game{game | black: black, card: card}
  end

  defp discard_black(%Game{card: nil} = game), do: game

  defp discard_black(%Game{black: black, card: card} = game) do
    black = Deck.discard(black, [card])
    %Game{game | black: black, card: nil}
  end
end
