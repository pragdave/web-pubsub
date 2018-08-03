defmodule Pubsub.Application do

  use Application

  def start(_type, _args) do
    children = [
      Pubsub.Server,
    ]

    opts = [strategy: :one_for_one, name: Pubsub.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
