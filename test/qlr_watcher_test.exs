defmodule QlrWatcherTest do
  use ExUnit.Case
  doctest QlrWatcher

  test "greets the world" do
    assert QlrWatcher.hello() == :world
  end
end
