defmodule Pubsub do

  @me Webo.Pubsub

  def name, do: @me


  def subscribe(topic, args) do
    GenServer.call(@me, { :subscribe, topic, args })
  end

  def trigger(topic, extra_args) do
    GenServer.cast(@me, { :trigger, topic, extra_args })
  end


end
