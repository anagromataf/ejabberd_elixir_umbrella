defmodule XMPP.Module do

  @doc false
  defmacro __using__(_) do
    quote location: :keep do
      use GenServer
      @behaviour :gen_mod

      import XMPP.Element

      ##
      ## gen_mode API
      ##

      @doc false
      def start(host, options) do
        proc = :gen_mod.get_module_proc(host, __MODULE__)
        child_spec = {proc, {__MODULE__, :start_link, [host, options]},
                      :temporary, 1000, :worker, [__MODULE__]}
        Supervisor.start_child(:ejabberd_sup, child_spec)
      end

      @doc false
      def stop(host) do
        proc = :gen_mod.get_module_proc(host, __MODULE__)
        GenServer.call(proc, :stop)
        Supervisor.terminate_child(:ejabberd_sup, proc)
        Supervisor.delete_child(:ejabberd_sup, proc)
      end

      ##
      ## GenServer (start_link)
      ##

      @doc false
      def start_link(host, options) do
        proc = :gen_mod.get_module_proc(host, __MODULE__)
        module_host = :gen_mod.get_opt_host(host, options, host)
        GenServer.start_link(__MODULE__, [module_host, options], [{:name, proc}])
      end

      @doc false
      def handle_call(:stop, _from, state) do
        {:stop, :normal, :ok, state}
      end

      @doc false
      def handle_info({:route, from, to, packet = xmlel(name: "message")}, state) do
        handle_message(from, to, packet, state)
      end

      @doc false
      def handle_info({:route, from, to, packet = xmlel(name: "iq")}, state) do
        iq = :jlib.iq_query_info(packet)
        handle_iq(from, to, iq, state)
      end

      ##
      ## Stanza Hnadling
      ##

      @doc false
      def handle_message(from, to, message, state) do
        {:noreply, state}
      end

      def handle_iq(from, to, message, state) do
        {:noreply, state}
      end

      defoverridable [handle_message: 4,
                      handle_iq: 4]

    end
  end

  def start(host, module, options) do
    :gen_mod.start_module(host, module, options)
  end

  def stop(host, module) do
    :gen_mod.stop_module(host, module)
  end

  def loaded(host) do
    :gen_mod.loaded_modules(host)
  end

end
