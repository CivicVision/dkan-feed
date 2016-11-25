defmodule DKAN.Job do
  use GenServer

  def start_link do
    IO.puts "start DKAN Scraper Job"
		DKAN.Scraper.start
		GenServer.start_link(__MODULE__, [], name: :dkan_updated_resources)
  end

	def add_resource(resource) do
    GenServer.cast(:dkan_updated_resources, {:add_resource, resource})
  end
  def get_resources do
    GenServer.call(:dkan_updated_resources, :get_resources)
  end

  def init(resources) do
    schedule_work() # Schedule work to be performed at some point
    {:ok, resources}
  end

  def handle_info(:work, resources) do
		resources = DKAN.Scraper.get_updated_resources
    IO.puts "DKAN Scraper results"
    DkanHandler.Broadcaster.sync_notify(resources)
    schedule_work() # Reschedule once more
    {:noreply, resources}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 5 * 60 * 1000) # In 5 minutes
  end

	def handle_cast({:add_resource, new_resource}, resources) do
    {:noreply, [new_resource | resources]}
  end

  def handle_call(:get_resources, _from, resources) do
    {:reply, resources, resources}
  end
end
