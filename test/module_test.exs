defmodule XMPP.ModuleTest do
  use ExUnit.Case, async: false

  defmodule Module do
    use XMPP.Module

    def init([host, _]) do
      XMPP.Router.register(host)
      {:ok, host}
    end

    def terminate(_, host) do
      XMPP.Router.unregister(host)
      :ok
    end
  end

  test "xmpp module starting and stopping" do
    ## start
    {:ok, _module} = XMPP.Module.start("localhost", Module, [])
    assert Enum.member?(XMPP.Module.modules("localhost"), Module)
    assert Keyword.has_key?(Supervisor.which_children(:ejabberd_sup), XMPP.ModuleTest.Module_localhost)

    ## stop
    assert :ok == XMPP.Module.stop("localhost", Module)
    refute Enum.member?(XMPP.Module.modules("localhost"), Module)
    refute Keyword.has_key?(Supervisor.which_children(:ejabberd_sup), XMPP.ModuleTest.Module_localhost)
  end

end
