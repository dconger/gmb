defmodule Gmb.Api.Location do
  @moduledoc false

  import Gmb, only: [parse: 2]
  import Gmb.Helpers, only: [ok: 1]

  alias Gmb.Api, as: GmbApi
  alias Gmb.Types

  import Mockery.Macro

  @as_struct %Gmb.LocationsList{
    locations: [%Gmb.Location{}]
  }

  @retry_options [
    attempts: 3,
    delay_time_ms: 100,
    delay_type: :constant,
    rescue_exceptions: []
  ]

  @spec fetch(Types.account_id(), Types.token()) :: {:ok | :error, any()}
  def fetch(account_id, token) do
    with {:ok, %HTTPoison.Response{body: result}} <-
      Mulligan.retry(
        fn ->
          account_id
          |> url()
          |> mockable(GmbApi).get(
            headers(token)
          )
        end,
        @retry_options
      ) |> GmbApi.handle_response()
    do
      result
      |> parse(as: @as_struct)
      |> ok()
    else
      error ->
        error
    end
  end

  defp my_business_url, do: "https://mybusiness.googleapis.com/v4/accounts/"

  defp url(account_id), do: my_business_url() <> account_id <> "/locations"

  defp headers(access_token) do
    [
      {"Authorization", "Bearer " <> access_token},
      {"Accept", "application/json"}
    ]
  end
end
