defmodule XMPP.Stanza do

  require Record
  require XMPP.Element

  Record.defrecord :iq, [id: "",
                         type: :get,
                         xmlns: "",
                         lang: "",
                         sub_el: XMPP.Element.xmlel()]

end
