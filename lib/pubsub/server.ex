defmodule Pubsub.Server do
  use GenServer
  alias Pubsub.Impl

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: Pubsub.name())
  end

  def init(_) do
    { :ok, %{} }
  end

  def handle_call({ :register, topic, args }, { from, _ref }, topics) do
    state = Impl.register(from, topics, topic, args)
    Process.monitor(from)
    { :reply, :ok, state }
  end

  def handle_cast({ :trigger, topic, extra_args }, topics) do
    Impl.trigger(topics, topic, extra_args)
    { :noreply,  topics}
  end

  def handle_info({ :DOWN, _ref, :process, pid, _reason }, topics) do
    IO.inspect DOWN: pid
    { :noreply, Impl.remove_subscriber(topics, pid) }
  end

end
