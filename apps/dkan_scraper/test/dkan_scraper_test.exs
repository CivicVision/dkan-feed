defmodule DkanScraperTest do
  use ExUnit.Case
  doctest DkanScraper

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "reutrns a resukt" do
    DKAN.Scraper.start
    assert DKAN.Scraper.get_updated_resources() == %{test: "foo"}
  end
end
