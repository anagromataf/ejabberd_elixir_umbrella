use Mix.Config

config :mnesia,
  dir: String.to_char_list("./var/")

config :ejabberd,
  config: String.to_char_list("./ejabberd.yml"),
  log_path: String.to_char_list("./log/ejabberd.log")
