defmodule XMPP.ModuleTest do
  use ExUnit.Case

  defmodule Echo do
    use XMPP.Module

    require Record
    require Logger

    Record.defrecord :state, [host: nil]

    def init([host, options]) do
      Logger.debug "Initalizing Module"
      echo_host = :gen_mod.get_opt_host(host, options, <<"echo.", host :: binary>>)
      :ejabberd_router.register_route(echo_host)
      {:ok, state(host: echo_host)}
    end

    def terminate(_, state) do
      Logger.debug "Terminating Module"
      :ejabberd_router.unregister_route(state.host)
      :ok
    end

    def handle_call(_, _form, state) do
      Logger.debug "Calling Module …"
      {:reply, :ok, state}
    end

  end

  ##
  ## Tests
  ##

  require Logger

  test "xmpp module starting and stopping" do

    ## Start the module "Echo" in the host "localhost"

    {:ok, module} = XMPP.Module.start("localhost", Echo, [])

    loaded_modules = XMPP.Module.loaded("localhost")
    assert Enum.member?(loaded_modules, Echo)

    children = Supervisor.which_children(:ejabberd_sup)
    assert Keyword.has_key?(children, XMPP.ModuleTest.Echo_localhost)

    assert :ok == GenServer.call(module, "foo")

    ## Stop the module "Echo"

    assert :ok == XMPP.Module.stop("localhost", Echo)

    loaded_modules = XMPP.Module.loaded("localhost")
    assert false == Enum.member?(loaded_modules, Echo)

    children = Supervisor.which_children(:ejabberd_sup)
    assert false == Keyword.has_key?(children, XMPP.ModuleTest.Echo_localhost)
  end

end
