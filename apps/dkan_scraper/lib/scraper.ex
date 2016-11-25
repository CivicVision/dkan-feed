defmodule DKAN.Scraper do
  use HTTPoison.Base

  @time_interval 5

  @expected_fields ~w(
    title url resources
  )
  @result ~w(
    result
  )

  def process_url(url) do
    "http://data.sandiego.gov" <> url
  end

  def process_response_body(body) do
    body
    |> Poison.decode!
  end

  def get_latest_resource do
    DKAN.Scraper.get!("/api/3/action/current_package_list_with_resources")
    |> Map.get(:body)
    |> Map.get("result")
    |> List.first
  end

  def get_updated_resources do
    get_latest_resource
    |> Enum.filter(&filter_in_resources(&1))
  end

  defp filter_in_resources(result) do
    result
    |> Map.get("resources")
    |> Enum.filter( fn(d) -> d["revision_timestamp"] |> parse_revision_timestamp |> is_updated_since_last_time end)
    |> is_updated?
  end

  defp is_updated?([]), do: false
  defp is_updated?(_), do: true

  defp parse_revision_timestamp(timestamp) do
    Timex.parse!(timestamp, "%a, %m/%d/%Y - %H:%M", :strftime)
  end

  defp is_updated_since_last_time(time) do
    #time1 = parse_revision_timestamp("Wed, 11/09/2016 - 00:15")
    Timex.diff(Timex.now, time, :minutes) < @time_interval
  end
end
