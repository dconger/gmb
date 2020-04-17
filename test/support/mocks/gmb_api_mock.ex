defmodule GmbApiMock do
  @moduledoc false

  alias HTTPoison.{Error, Response}

  @uris [
    {~r(^https://www.googleapis.com/oauth2/v4/token$), :token},
    {~r(^https://mybusiness.googleapis.com/v4/accounts/\d+/locations$), :locations},
    {~r(^https://mybusiness.googleapis.com/v4/accounts/\d+/locations:reportInsights$), :insights}
  ]

  def post(uri, _, _), do: uri |> route() |> handle_uri()
  def get(uri, _), do: uri |> route() |> handle_uri()

  defp route(uri) do
    {_, handler} =
      Enum.find(@uris, {nil, :unknown}, fn {reg, _} ->
        String.match?(uri, reg)
      end)

    {handler, uri}
  end

  defp handle_uri({:token, _uri}) do
    {:ok, %Response{body: {:ok, %{"access_token" => "fake-token"}}, status_code: 200}}
  end

  defp handle_uri({:locations, _uri}) do
    {:ok, %Response{body: {:ok, %{"locations" => [%{"name" => "location-1"}]}}, status_code: 200}}
  end

  defp handle_uri({:insights, _uri}) do
    {:ok,
     %Response{
       body:
         {:ok,
          %{
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
          }},
       status_code: 200
     }}
  end

  defp handle_uri({:unknown, _uri}) do
    {:ok, %Error{reason: "uri is not mocked out"}}
  end
end
