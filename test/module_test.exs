defmodule XMPP.ModuleTest do
  use ExUnit.Case

  defmodule Echo do
    use XMPP.Module

    def init([host, _options]) do
      XMPP.Router.register(host)
      {:ok, host}
    end

    def terminate(_, host) do
      XMPP.Router.unregister(host)
      :ok
    end

    def handle_call(:host, _from, host) do
      {:reply, host, host}
    end

  end

  ##
  ## Tests
  ##

  require Logger

  test "xmpp module starting and stopping" do

    ## Start the module "Echo" in the host "localhost"

    {:ok, module} = XMPP.Module.start("localhost", Echo, [{:host, <<"echo.@HOST@">>}])

    loaded_modules = XMPP.Module.loaded("localhost")
    assert Enum.member?(loaded_modules, Echo)

    children = Supervisor.which_children(:ejabberd_sup)
    assert Keyword.has_key?(children, XMPP.ModuleTest.Echo_localhost)

    assert "echo.localhost" == GenServer.call(module, :host)

    ## Stop the module "Echo"

    assert :ok == XMPP.Module.stop("localhost", Echo)

    loaded_modules = XMPP.Module.loaded("localhost")
    assert false == Enum.member?(loaded_modules, Echo)

    children = Supervisor.which_children(:ejabberd_sup)
    assert false == Keyword.has_key?(children, XMPP.ModuleTest.Echo_localhost)
  end

end
