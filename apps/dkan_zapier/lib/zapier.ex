defmodule DkanZapier.Zapier do

  @zapier_webhook 'https://hooks.zapier.com/hooks/catch/552616/th9cyu/'

  def send_to_hook(data) do
    zapier_data = %{ name: data["title"], url: data["url"]}
    IO.puts "Send data to zapier "
    IO.inspect {"Incoming Data", data}
    IO.inspect {self(), zapier_data}
    HTTPoison.post @zapier_webhook, Poison.encode!(zapier_data), [{"Content-Type", "application/json"}]
  end
end
