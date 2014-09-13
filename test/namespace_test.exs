defmodule XMPP.NamespaceTest do
  use ExUnit.Case

  require XMPP.Namespace

  test "ping namespace" do
    assert XMPP.Namespace.ping == "urn:xmpp:ping"
  end

end
