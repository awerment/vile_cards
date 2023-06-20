defmodule VileCards.Deck do
  def draw(deck, num) do
    do_draw(deck, num, [])
  end

  def discard({draw, discard}, items) do
    {draw, [items | discard]}
  end

  defp do_draw({[], discard}, num, drawn) do
    do_draw({Enum.shuffle(List.flatten(discard)), []}, num, drawn)
  end

  defp do_draw(deck, 0, drawn), do: {deck, drawn}

  defp do_draw({[top | rest] = _draw, discard}, num, drawn) do
    do_draw({rest, discard}, num - 1, [top | drawn])
  end
end
