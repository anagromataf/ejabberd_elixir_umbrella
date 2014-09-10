defmodule XMPP.ModuleTest do
  use ExUnit.Case

  defmodule Echo do
    use XMPP.Module

    defmodule State do
      defstruct host: nil
    end

    require Logger

    def init([host, _options]) do
      Logger.debug "Initalizing Module for host: " <> host
      XMPP.Router.register(host)
      {:ok, %State{host: host}}
    end

    def terminate(_, state) do
      Logger.debug "Terminating Module for host: " <> state.host
      XMPP.Router.unregister(state.host)
      :ok
    end

    def handle_call(:host, _from, state) do
      Logger.debug "Calling Module …"
      {:reply, state.host, state}
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
