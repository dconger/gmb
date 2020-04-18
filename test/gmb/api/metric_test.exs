defmodule Gmb.Api.MetricTest do
  use ExUnit.Case, async: false

  alias Gmb.Api
  alias Gmb.Api.Metric

  import Mockery
  import Mockery.Assertions

  describe "fetch/2" do
    @tag :dan
    test "will correctly parse successfull call to GMB api" do
      mock(
        Api,
        [post: 3],
        {:ok,
     %HTTPoison.Response{
       body: %{
            "locationMetrics" => [
              %{
                "locationName" => "location-1",
                "metricValues" => [
                  %{
                    "metric" => "QUERIES_DIRECT",
                    "dimensionalValues" => [
                      %{
                        "timeDimension" => %{
                          "timeRange" => %{
                            "startTime" => DateTime.utc_now() |> DateTime.to_iso8601()
                          }
                        }
                      }
                    ]
                  }
                ]
              }
            ]
          },
       status_code: 200
     }}
      )

      account_id = "1"
      token = ""
      list = []
      start_time = ""
      finish_time = ""

      {:ok, %Gmb.ReportInsight{} = result} = Metric.fetch(account_id, token, list, start_time, finish_time)
    end
  end
end
