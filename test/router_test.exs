defmodule XMPP.RouterTest do
    use ExUnit.Case

    require XMPP.Namespace

    import XMPP.Element

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

      def handle_presence(from, to, stanza, state) do
        {_, pid} = state
        send pid, {:handle_presence, from, to, stanza}
        {:noreply, state}
      end

      def handle_message(from, to, stanza, state) do
        {_, pid} = state
        send pid, {:handle_message, from, to, stanza}
        {:noreply, state}
      end

      def handle_iq(from, to, stanza, state) do
        {_, pid} = state
        send pid, {:handle_iq, from, to, stanza}
        {:noreply, state}
      end

    end

    setup do
      module_host = "test.localhost"
      test_host = "foo.localhost"
      XMPP.Router.register(test_host)
      {:ok, _} = XMPP.Module.start(module_host, Test, [{:pid, self()}])
      on_exit fn ->
                XMPP.Router.unregister(test_host)
                XMPP.Module.stop(module_host, Test)
      end
      {:ok, [module: module_host, local: test_host]}
    end

    test "route stanza", %{local: local} do
      from = XMPP.Jid.new("test@example.com")
      to = XMPP.Jid.new(local)
      stanza = xmlel(name: "message")
      XMPP.Router.route(from, to, stanza)
      assert_receive {:route, ^from, ^to, ^stanza}
    end

    test "handle message stanze", %{module: module} do
      from = XMPP.Jid.new("test@example.com")
      to = XMPP.Jid.new(module)
      stanza = XMPP.Element.xmlel(name: "message")
      XMPP.Router.route(from, to, stanza)
      assert_receive {:handle_message, ^from, ^to, ^stanza}
    end

    test "handle iq stanze", %{module: module} do
      from = XMPP.Jid.new("test@example.com")
      to = XMPP.Jid.new(module)
      stanza = xmlel(name: "iq")
      XMPP.Router.route(from, to, stanza)
      assert_receive {:handle_iq, ^from, ^to, ^stanza}
    end

    test "handle presence stanze", %{module: module} do
      from = XMPP.Jid.new("test@example.com")
      to = XMPP.Jid.new(module)
      stanza = xmlel(name: "presence")
      XMPP.Router.route(from, to, stanza)
      assert_receive {:handle_presence, ^from, ^to, ^stanza}
    end

end
