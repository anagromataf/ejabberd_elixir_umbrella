defmodule XMPP.RouterTest do
    use ExUnit.Case

    setup do
      XMPP.Router.register("foo.localhost")
      on_exit fn -> XMPP.Router.unregister("foo.localhost") end
    end

    test "send message to self" do
      from = XMPP.Jid.create("test@example.com")
      to = XMPP.Jid.create("foo.localhost")
      packet = :ping
      XMPP.Router.route(from, to, packet)
      assert_receive {:route, from, to, packet}
    end
end
