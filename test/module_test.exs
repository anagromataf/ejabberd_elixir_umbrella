defmodule XMPP.ModuleTest do
  use ExUnit.Case, async: false

  defmodule Echo do
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
    {:ok, _module} = XMPP.Module.start("localhost", Echo, [{:host, <<"echo.@HOST@">>}])
    assert Enum.member?(XMPP.Module.loaded("localhost"), Echo)
    assert Keyword.has_key?(Supervisor.which_children(:ejabberd_sup), XMPP.ModuleTest.Echo_localhost)

    ## stop
    assert :ok == XMPP.Module.stop("localhost", Echo)
    refute Enum.member?(XMPP.Module.loaded("localhost"), Echo)
    refute Keyword.has_key?(Supervisor.which_children(:ejabberd_sup), XMPP.ModuleTest.Echo_localhost)
  end

end
