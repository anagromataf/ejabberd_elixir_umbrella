defmodule XMPP.Jid do

  require Record
  Record.defrecord :jid, Record.extract(:jid, from_lib: "ejabberd/include/jlib.hrl")

  def create(jid_string) do
    :jlib.string_to_jid(jid_string)
  end

  def create(user, server, resource) do
    :jlib.make_jid(user, server, resource)
  end

  def user(j) do jid(j, :user) end
  def server(j) do jid(j, :server) end
  def resource(j) do jid(j, :resource) end

end
