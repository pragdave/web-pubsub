defmodule PubsubTest do
  use ExUnit.Case

  test "basic registration of self()" do
    my_little_subscriber(:topic, "wombat")
    :timer.sleep(10)
    Pubsub.trigger(:topic, :trigger_args)
  end

  test "registraion of two processes for one trigger" do
    my_little_subscriber(:another_topic, "koala")
    my_little_subscriber(:another_topic, "kangaroo")
    :timer.sleep(10)
    Pubsub.trigger(:another_topic, :trigger_args)
  end

  test "registraion of two processes for two triggers" do
    my_little_subscriber(:third_topic, "koala")
    my_little_subscriber(:fourth_topic, "kangaroo")
    :timer.sleep(10)
    Pubsub.trigger(:fourth_topic, :trigger_args)
    Pubsub.trigger(:third_topic, :trigger_args)
  end



  def my_little_subscriber(topic, code) do
    spawn(fn ->
      Pubsub.subscribe(topic, code)
      assert_receive( {
        :trigger,
        topic,
        code,
        :trigger_args
      })
    end)
  end
end
