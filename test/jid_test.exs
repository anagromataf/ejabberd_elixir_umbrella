defmodule XMPP.JidTest do
  use ExUnit.Case

  require XMPP.Jid

  test "new jid with components" do
    jid = XMPP.Jid.new("test", "example.com", "Resource")
    assert XMPP.Jid.user(jid) == "test"
    assert XMPP.Jid.server(jid) == "example.com"
    assert XMPP.Jid.resource(jid) == "Resource"
  end

  test "new jid from stirng" do
    jid = XMPP.Jid.new("test@example.com/Resource")
    assert XMPP.Jid.user(jid) == "test"
    assert XMPP.Jid.server(jid) == "example.com"
    assert XMPP.Jid.resource(jid) == "Resource"
  end

end
