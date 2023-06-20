defmodule VileCards.Game do
  defstruct players: %{}, black: {[], []}, white: {[], []}, round: 0, card: nil

  alias VileCards.{Deck, Game, Player}

  def new({id, name} = _admin, black, white) do
    %Game{
      players: %{id => Player.new(id, name)},
      black: {black, []},
      white: {white, []}
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

  def start_round(%Game{black: black, round: round} = game) do
    {black, [card]} = Deck.draw(black, 1)

    %Game{game | black: black, round: round + 1, card: card} |> deal()
  end
end
