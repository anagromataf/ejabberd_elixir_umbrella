defmodule XMPP.LoadModuleTest do
  use ExUnit.Case

  test "load module via config" do
    assert Enum.member?(XMPP.Module.modules("localhost"), XMPP.Dummy)
  end

end
