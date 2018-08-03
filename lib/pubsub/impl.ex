defmodule Pubsub.Impl do

  def subscribe(from, topics, topic, args) do
    subscription =  %Pubsub.Subscriber{ pid: from, subscriber_args: args }
    Map.update(topics, topic, [ subscription ], &[ subscription | &1 ])
  end

  def trigger(topics, topic, extra_args) do
    entry = topics[topic]
    send_to(topic, entry, extra_args)
  end

  def remove_subscriber(topics, pid) do
    topics
    |> Enum.reduce([], fn ({ topic, subscribers }, result) ->
      new_subscribers = subscribers |> remove_pid(pid)
      if length(new_subscribers) > 0 do
        [ { topic, new_subscribers } | result ]
      else
        result
      end
    end)
    |> Enum.into(%{})
  end

  defp send_to(topic, nil, extra_args) do
    raise "Someone triggered #{inspect topic}(#{inspect extra_args}) but no one is subscribed"
  end

  defp send_to(topic, subscribers, extra_args) do
    for subscriber <- subscribers do
      send subscriber.pid, { :trigger, topic, subscriber.subscriber_args, extra_args }
    end
  end

  defp remove_pid(subscribers, pid) do
    subscribers
    |> Enum.reject(fn subscriber -> subscriber.pid == pid end)
  end
end
