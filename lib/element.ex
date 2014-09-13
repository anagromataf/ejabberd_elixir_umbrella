defmodule XMPP.Element do

  require Record
  Record.defrecord :xmlel, Record.extract(:xmlel, from_lib: "ejabberd/include/xml.hrl")

end
