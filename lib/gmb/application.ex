defmodule Gmb.Application do
  @moduledoc """
  Module for Google My Business Api v4.
  """
  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: Gmb.Worker.start_link(arg)
      # {Gmb.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Gmb.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
