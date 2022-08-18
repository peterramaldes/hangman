defmodule Lists do

  def len([]),    do: 0 
  def len([_|t]), do: 1 + len(t)

  def sum([]),    do: 0 
  def sum([h|t]), do: h + sum(t)

  def square([]),    do: [] 
  def square([h|t]), do: [h*h|square(t)]

  def double([]),    do: [] 
  def double([h|t]), do: [2*h|square(t)]

  def map([], _),       do: []
  def map([h|t], func), do: [func.(h)|map(t, func)]

  def sum_pairs([]),         do: []
  def sum_pairs([h1,h2|t]),  do: [h1+h2|sum_pairs(t)]

  def even_length?([]),    do: false
  def even_length?([_|t]), do: rem(length(t)+1, 2) == 0

end
