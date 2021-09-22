defmodule Cidr.Util do
  def ones(n) when n >= 0, do: ones(n, <<>>)
  def ones(0, bin), do: bin
  def ones(n, bin), do: ones(n - 1, <<(<<1::size(1)>>), bin::bitstring>>)

  def zeros(n) when n >= 0, do: <<0::size(n)>>
end
