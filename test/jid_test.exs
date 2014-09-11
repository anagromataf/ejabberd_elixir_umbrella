defmodule XMPP.JidTest do
  use ExUnit.Case

  require XMPP.Jid

  test "create jid" do
    jid = XMPP.Jid.create("test", "example.com", "Resource")
    assert XMPP.Jid.user(jid) == "test"
    assert XMPP.Jid.server(jid) == "example.com"
    assert XMPP.Jid.resource(jid) == "Resource"
  end

  test "jid from stirng" do
    jid = XMPP.Jid.create("test@example.com/Resource")
    assert XMPP.Jid.user(jid) == "test"
    assert XMPP.Jid.server(jid) == "example.com"
    assert XMPP.Jid.resource(jid) == "Resource"
  end

end
