defmodule XMPP.ElementTest do
  use ExUnit.Case

  require XMPP.Element

  test "create xml element" do
    element = XMPP.Element.xmlel(name: "foo")
    assert XMPP.Element.xmlel(element, :name) == "foo"
  end

end
