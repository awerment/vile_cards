defmodule VileCards.DeckTest do
  use ExUnit.Case

  alias VileCards.Deck

  describe "draw/2" do
    test "returns tuple with updated deck and drawn cards" do
      draw_pile = Enum.to_list(1..100)
      discard_pile = []
      deck = {draw_pile, discard_pile}

      assert {updated_deck, drawn} = Deck.draw(deck, 10)

      assert Enum.reverse(drawn) == Enum.to_list(1..10)
      assert updated_deck == {Enum.to_list(11..100), []}
    end

    test "if not enough cards in draw pile, (flattens and) re-shuffles discard pile" do
      draw_pile = [1, 2]
      discard_pile = [[3, 4, 5] | Enum.to_list(6..100)]
      deck = {draw_pile, discard_pile}

      assert {{updated_draw_pile, updated_discard_pile}, drawn} = Deck.draw(deck, 10)
      assert updated_discard_pile == []
      assert 1 in drawn and 2 in drawn
      assert Enum.count(drawn) == 10
      assert Enum.sort(updated_draw_pile) == Enum.to_list(1..100) -- drawn
      refute updated_draw_pile == Enum.to_list(1..100) -- drawn
    end
  end

  describe "discard/2" do
    test "puts given items on the discard pile, returning the updated deck" do
      draw_pile = [7, 8, 9, 0]
      discard_pile = [1, 2, 3, 4]
      deck = {draw_pile, discard_pile}

      assert {^draw_pile, updated_discard_pile} = Deck.discard(deck, [5, 6])
      assert updated_discard_pile == [[5, 6] | discard_pile]
    end
  end
end
