defmodule XMPP.Stanza do
  import XMPP.Element
  require Record
  Record.defrecord :iq, [id: "", type: :get, xmlns: "", lang: "", sub_el: xmlel()]
end
