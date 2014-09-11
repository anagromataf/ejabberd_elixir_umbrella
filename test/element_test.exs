defmodule XMPP.ElementTest do
  use ExUnit.Case

  test "create xml element" do
    element = XMPP.Element.create("foo")
    assert XMPP.Element.name(element) == "foo"
  end

end
