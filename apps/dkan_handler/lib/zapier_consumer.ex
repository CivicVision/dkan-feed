alias Experimental.{GenStage}
defmodule DkanHandler.ZapierConsumer do
	use GenStage

  def start_link() do
    GenStage.start_link(__MODULE__, :ok)
  end

  # Callbacks

  def init(:ok) do
    # Starts a permanent subscription to the broadcaster
    # which will automatically start requesting items.
    IO.puts "DKAN Consumer start"
    {:consumer, :ok, subscribe_to: [DkanHandler.Broadcaster]}
  end

  def handle_events(events, _from, state) do
    IO.puts "DKAN Consumer notify"
    for event <- events do
      IO.inspect {self(), event}
      event
      |> List.flatten
      |> Enum.each(fn(x) -> DkanZapier.Zapier.send_to_hook(x) end)
    end
    {:noreply, [], state}
  end
end
