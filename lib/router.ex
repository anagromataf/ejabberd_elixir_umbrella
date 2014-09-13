defmodule XMPP.Router do

  require Record
  require XMPP.Stanza

  def register(host) do
    :ejabberd_router.register_route(host)
  end

  def unregister(host) do
    :ejabberd_router.unregister_route(host)
  end

  def route(from, to, iq = XMPP.Stanza.iq()) do
    sub_el = case XMPP.Stanza.iq(iq, :sub_el) do
               els when is_list(els) -> els
               el -> [el]
    end
    packet = :jlib.iq_to_xml(XMPP.Stanza.iq(iq, sub_el: sub_el))
    route(from, to, packet)
  end

  def route(from, to, packet) do
    :ejabberd_router.route(from, to, packet)
  end

end
