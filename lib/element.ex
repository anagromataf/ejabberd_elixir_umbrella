defmodule XMPP.Element do

  require Record
  Record.defrecord :xmlel, Record.extract(:xmlel, from_lib: "ejabberd/include/xml.hrl")

  def create(name, attributes \\ [], children \\ []) do
    xmlel(name: name, attrs: attributes, children: children)
  end

  def name(e) do xmlel(e, :name) end
  def attributes(e) do xmlel(e, :attrs) end
  def children(e) do xmlel(e, :children) end

end
