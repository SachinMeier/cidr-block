defmodule CidrTest do
  use ExUnit.Case
  doctest Cidr

  @valid_cidr_blocks [
    %{
      cidr_str: "10.0.0.0/0",
      base_ip: "10.0.0.0",
      cidr_list: [10, 0, 0, 0, 0],
      cidr_obj: %Cidr{a: 10, b: 0, c: 0, d: 0, mask: 0},
      subnet_mask: "0.0.0.0",
      address_count: 4_294_967_296,
      subnet_max_addr: "255.255.255.255"
    },
    %{
      cidr_str: "10.0.0.0/1",
      base_ip: "10.0.0.0",
      cidr_list: [10, 0, 0, 0, 1],
      cidr_obj: %Cidr{a: 10, b: 0, c: 0, d: 0, mask: 1},
      subnet_mask: "128.0.0.0",
      address_count: 2_147_483_648,
      subnet_max_addr: "127.255.255.255"
    },
    %{
      cidr_str: "10.0.0.0/10",
      base_ip: "10.0.0.0",
      cidr_list: [10, 0, 0, 0, 10],
      cidr_obj: %Cidr{a: 10, b: 0, c: 0, d: 0, mask: 10},
      subnet_mask: "255.192.0.0",
      address_count: 4_194_304,
      subnet_max_addr: "10.63.255.255"
    },
    %{
      cidr_str: "10.0.0.0/14",
      base_ip: "10.0.0.0",
      cidr_list: [10, 0, 0, 0, 14],
      cidr_obj: %Cidr{a: 10, b: 0, c: 0, d: 0, mask: 14},
      subnet_mask: "255.252.0.0",
      address_count: 262_144,
      subnet_max_addr: "10.3.255.255"
    },
    %{
      cidr_str: "10.0.0.0/18",
      base_ip: "10.0.0.0",
      cidr_list: [10, 0, 0, 0, 18],
      cidr_obj: %Cidr{a: 10, b: 0, c: 0, d: 0, mask: 18},
      subnet_mask: "255.255.192.0",
      address_count: 16384,
      subnet_max_addr: "10.0.63.255"
    },
    %{
      cidr_str: "10.0.0.0/19",
      base_ip: "10.0.0.0",
      cidr_list: [10, 0, 0, 0, 19],
      cidr_obj: %Cidr{a: 10, b: 0, c: 0, d: 0, mask: 19},
      subnet_mask: "255.255.224.0",
      address_count: 8192,
      subnet_max_addr: "10.0.31.255"
    },
    %{
      cidr_str: "10.0.0.0/24",
      base_ip: "10.0.0.0",
      cidr_list: [10, 0, 0, 0, 24],
      cidr_obj: %Cidr{a: 10, b: 0, c: 0, d: 0, mask: 24},
      subnet_mask: "255.255.255.0",
      address_count: 256,
      subnet_max_addr: "10.0.0.255"
    },
    %{
      cidr_str: "10.0.0.0/28",
      base_ip: "10.0.0.0",
      cidr_list: [10, 0, 0, 0, 28],
      cidr_obj: %Cidr{a: 10, b: 0, c: 0, d: 0, mask: 28},
      subnet_mask: "255.255.255.240",
      address_count: 16,
      subnet_max_addr: "10.0.0.15"
    },
    %{
      cidr_str: "10.0.0.0/31",
      base_ip: "10.0.0.0",
      cidr_list: [10, 0, 0, 0, 31],
      cidr_obj: %Cidr{a: 10, b: 0, c: 0, d: 0, mask: 31},
      subnet_mask: "255.255.255.254",
      address_count: 2,
      subnet_max_addr: "10.0.0.1"
    }
  ]

  describe "CIDR creation" do
    test "new/1" do
      for c <- @valid_cidr_blocks do
        assert Cidr.new(c.cidr_list) == c.cidr_obj
      end
    end

    test "from_string/1" do
      for c <- @valid_cidr_blocks do
        assert Cidr.from_string(c.cidr_str) == c.cidr_obj
      end
    end
  end

  describe "repr functions" do
    test "to_string/1" do
      for c <- @valid_cidr_blocks do
        assert Cidr.to_string(c.cidr_obj) == c.cidr_str
      end
    end

    test "to_ip/1" do
      for c <- @valid_cidr_blocks do
        assert Cidr.to_string(c.cidr_obj) == c.cidr_str
      end
    end

    test "get_mask_string/1" do
      for c <- @valid_cidr_blocks do
        assert Cidr.get_mask_string(c.cidr_obj) == c.subnet_mask
      end
    end
  end

  describe "data functions" do
    test "get_subnet_max_address/1" do
      for c <- @valid_cidr_blocks do
        assert Cidr.get_subnet_max_address(c.cidr_obj) == c.subnet_max_addr
      end
    end

    test "address_count/1" do
      for c <- @valid_cidr_blocks do
        assert Cidr.address_count(c.cidr_obj) == c.address_count
      end
    end
  end
end
