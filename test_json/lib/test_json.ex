defmodule TestJSON do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    IO.puts "#{__MODULE__} application started"
 
    children = [
      supervisor(TestJSON.Repo, [])
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
