defmodule Gmb.Api.Metric do
  @moduledoc false

  alias Gmb.Api, as: GmbApi
  alias Gmb.Errors.ResponseParseError
  alias Gmb.Types

  import Mockery.Macro

  @retry_options [
    attempts: 3,
    delay_time_ms: 100,
    delay_type: :constant,
    rescue_exceptions: [ResponseParseError]
  ]

  @spec fetch(Types.account_id(), Types.token(), list(), Types.date(), Types.date()) :: {:ok | :error, any()}
  def fetch(account_id, token, location_names, start_time, end_time) do
    Mulligan.retry(
      fn ->
        account_id
        |> url()
        |> mockable(GmbApi, by: GmbApiMock).post(
          fetch_body(location_names, start_time, end_time),
          headers(token)
        )
      end,
      @retry_options
    )
  end

  defp my_business_url, do: "https://mybusiness.googleapis.com/v4/accounts/"

  defp url(account_id), do: my_business_url() <> account_id <> "/locations:reportInsights"

  defp fetch_body(names, start_time, end_time) do
    %{
      "locationNames" => names,
      "basicRequest" => %{
        "metricRequests" => %{
          "metric" => "ALL",
          "options" => "AGGREGATED_DAILY"
        },
        "timeRange" => %{
          "startTime" => start_time,
          "endTime" => end_time
        }
      }
    }
  end

  defp headers(access_token) do
    [
      {"Authorization", "Bearer " <> access_token},
      {"Content-Type", "application/json"},
      {"Accept", "application/json"}
    ]
  end
end
