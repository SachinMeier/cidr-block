defmodule Cidr do
  @moduledoc """
    Documentation for `Cidr`.
  """

  use Bitwise
  alias Cidr.Util

  @bitlength 32

  @type t() :: %__MODULE__{
          a: integer(),
          b: integer(),
          c: integer(),
          d: integer(),
          mask: integer()
        }

  defstruct [
    :a,
    :b,
    :c,
    :d,
    :mask
  ]

  @doc """
    new creates a new CIDR Block a.b.c.d/mask from a list of integers
    [a, b, c, d, mask]
  """
  @spec new(list(integer)) :: t()
  def new([a, b, c, d, mask]) do
    validate_cidr_block([a, b, c, d, mask])
  end

  @doc """
    from_string parses a CIDR Block from its string representation
  """
  @spec from_string(String.t()) :: t()
  def from_string(cidr_block) do
    cidr_block
    |> String.split([".", "/"])
    |> Enum.map(&String.to_integer/1)
    |> validate_cidr_block()
  end

  @doc """
    to_string returns a string representation of the CIDR Block
  """
  @spec to_string(t()) :: String.t()
  def to_string(%__MODULE__{a: a, b: b, c: c, d: d, mask: mask}),
    do: "#{a}.#{b}.#{c}.#{d}/#{mask}"

  @doc """
    to_ip returns a string representation of the first IP address of the CIDR Block,
    dropping the mask length.
  """
  @spec to_ip(t()) :: String.t()
  def to_ip(%__MODULE__{a: a, b: b, c: c, d: d}), do: "#{a}.#{b}.#{c}.#{d}"

  @doc """
    to_bin returns a binary representation of the CIDR Block
  """
  @spec to_bin(t()) :: binary
  def to_bin(%__MODULE__{a: a, b: b, c: c, d: d, mask: _mask}), do: <<a, b, c, d>>

  @doc """
    get_mask_bin returns the binary representation of the Subnet Mask
  """
  @spec get_mask_bin(t()) :: binary
  def get_mask_bin(%__MODULE__{mask: mask}) do
    <<Util.ones(mask)::bitstring, Util.zeros(@bitlength - mask)::bitstring>>
  end

  @spec get_mask_int(t()) :: integer
  def get_mask_int(cidr) do
    cidr
    |> get_mask_bin()
    |> :binary.decode_unsigned()
  end

  @spec get_mask_inverse(t()) :: integer
  defp get_mask_inverse(%__MODULE__{mask: mask}) do
    <<Util.zeros(mask)::bitstring, Util.ones(@bitlength - mask)::bitstring>>
    |> :binary.decode_unsigned()
  end

  @doc """
    get_mask_string returns the string representation of the Subnet Mask
  """
  @spec get_mask_string(t()) :: String.t()
  def get_mask_string(cidr_block = %__MODULE__{}) do
    cidr_block
    |> get_mask_bin()
    |> :binary.bin_to_list()
    |> Enum.map(&Integer.to_string/1)
    |> Enum.join(".")
  end

  @doc """
    get_subnet_max_address returns the IP representation of the largest
    IP address in this CIDR Block
  """
  @spec get_subnet_max_address(t()) :: String.t()
  def get_subnet_max_address(cidr = %__MODULE__{mask: mask}) do
    subnet_mask = get_mask_int(cidr)
    inverse_mask = get_mask_inverse(cidr)

    <<a, b, c, d>> =
      cidr
      |> to_bin()
      |> :binary.decode_unsigned()
      |> Bitwise.band(subnet_mask)
      |> Bitwise.bor(inverse_mask)
      |> :binary.encode_unsigned()

    %__MODULE__{a: a, b: b, c: c, d: d, mask: mask}
    |> to_ip()
  end

  defp validate_cidr_block([a, b, c, d, mask])
       when a >= 0 and a < 256 and
              b >= 0 and b < 256 and
              c >= 0 and c < 256 and
              d >= 0 and d < 256 and
              mask >= 0 and mask < @bitlength do
    %__MODULE__{a: a, b: b, c: c, d: d, mask: mask}
  end

  defp validate_cidr_block(_), do: raise(ArgumentError, message: "invalid CIDR block")

  @doc """
    address_count returns the number of addresses (hosts) in this CIDR Block
  """
  @spec address_count(t()) :: integer()
  def address_count(%__MODULE__{mask: mask}), do: :math.pow(2, @bitlength - mask) |> trunc()

  @doc """
    useable_address_count returns the number of *useable* addresses (hosts) 
    in this CIDR Block. This is always 2 less than the address_count.
  """
  @spec useable_address_count(t()) :: integer()
  def useable_address_count(cidr_block), do: address_count(cidr_block) - 2

  @doc """
    cidr_to_range returns a string summary of this CIDR Block Range,
    including the minimum and maximum IP address and the address_count.
  """
  @spec cidr_to_range(String.t()) :: String.t()
  def cidr_to_range(cidr_str) do
    cidr_block = from_string(cidr_str)

    "#{cidr_str}: #{to_ip(cidr_block)} - #{get_subnet_max_address(cidr_block)} (#{
      address_count(cidr_block)
    })\n"
  end
end
