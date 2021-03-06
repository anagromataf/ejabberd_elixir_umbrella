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
        GenServer.start_link(__MODULE__, [host, options], [{:name, proc}])
      end

      @doc false
      def handle_call(:stop, _from, state) do
        {:stop, :normal, :ok, state}
      end

      @doc false
      def handle_info({:route, from, to, stanza = xmlel(name: "presence")}, state) do
        handle_presence(from, to, stanza, state)
      end

      @doc false
      def handle_info({:route, from, to, stanza = xmlel(name: "message")}, state) do
        handle_message(from, to, stanza, state)
      end

      @doc false
      def handle_info({:route, from, to, stanza = xmlel(name: "iq")}, state) do
        handle_iq(from, to, stanza, state)
      end

      ##
      ## Stanza Hnadling
      ##

      @doc false
      def handle_presence(from, to, stanza, state) do
        {:noreply, state}
      end

      @doc false
      def handle_message(from, to, stanza, state) do
        {:noreply, state}
      end

      @doc false
      def handle_iq(from, to, stanza, state) do
        {:noreply, state}
      end

      ##
      ## "Exports"
      ##

      defoverridable [handle_presence: 4,
                      handle_message: 4,
                      handle_iq: 4]

    end
  end

  def start(host, module, options) do
    :gen_mod.start_module(host, module, options)
  end

  def stop(host, module) do
    :gen_mod.stop_module(host, module)
  end

  def modules(host) do
    :gen_mod.loaded_modules(host)
  end

end
