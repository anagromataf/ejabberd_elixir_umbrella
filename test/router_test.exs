defmodule XMPP.RouterTest do
    use ExUnit.Case

    require XMPP.Namespace
    require XMPP.Element
    require XMPP.Stanza
    require Logger

    defmodule Test do
      use XMPP.Module

      def init([host, options]) do
        XMPP.Router.register(host)
        {:ok, {host, options[:pid]}}
      end

      def terminate(_, {host, _pid}) do
        XMPP.Router.unregister(host)
        :ok
      end

      def handle_message(from, to, message, state) do
        {host, pid} = state
        send pid, {:handle_message, from, to, message}
        {:noreply, {host, pid}}
      end

      def handle_iq(from, to, iq, state) do
        {host, pid} = state
        send pid, {:handle_iq, from, to, iq}
        {:noreply, {host, pid}}
      end

    end

    setup do
      XMPP.Router.register("foo.localhost")
      {:ok, _} = XMPP.Module.start("localhost", Test, [{:host, <<"test.@HOST@">>}, {:pid, self()}])
      on_exit fn ->
                XMPP.Router.unregister("foo.localhost")
                XMPP.Module.stop("localhost", Test)
      end
    end

    test "route packet" do
      from = XMPP.Jid.new("test@example.com")
      to = XMPP.Jid.new("foo.localhost")
      packet = XMPP.Element.xmlel(name: "message")
      XMPP.Router.route(from, to, packet)
      assert_receive {:route, ^from, ^to, ^packet}
    end

    test "handle message" do
      from = XMPP.Jid.new("test@example.com")
      to = XMPP.Jid.new("test.localhost")
      message = XMPP.Element.xmlel(name: "message")
      XMPP.Router.route(from, to, message)
      assert_receive {:handle_message, ^from, ^to, ^message}
    end

    test "handle iq" do
      from = XMPP.Jid.new("test@example.com")
      to = XMPP.Jid.new("test.localhost")
      ns = XMPP.Namespace.ping
      iq = XMPP.Stanza.iq(type: :get,
                          xmlns: ns,
                          sub_el: XMPP.Element.xmlel(name: "query",
                                                     attrs: [{"xmlns", ns}]))
      XMPP.Router.route(from, to, iq)
      assert_receive {:handle_iq, ^from, ^to, ^iq}
    end
end
