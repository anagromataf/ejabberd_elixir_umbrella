defmodule XMPP.Router do

  def register(host) do
    :ejabberd_router.register_route(host)
  end

  def unregister(host) do
    :ejabberd_router.unregister_route(host)
  end

  def route(from, to, packet) do
    :ejabberd_router.route(from, to, packet)
  end

end
