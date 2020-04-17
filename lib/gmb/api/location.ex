defmodule Gmb.Api.Location do
  @moduledoc false

  import Gmb, only: [parse: 2]

  alias Gmb.Api, as: GmbApi
  alias Gmb.Errors.ResponseParseError
  alias Gmb.Types

  import Mockery.Macro

  @as_struct %Gmb.Location{}
  
  @retry_options [
    attempts: 3,
    delay_time_ms: 100,
    delay_type: :constant,
    rescue_exceptions: [ResponseParseError]
  ]

  @spec fetch(Types.account_id(), Types.token()) :: {:ok | :error, any()}
  def fetch(account_id, token) do
    result =
      Mulligan.retry(
        fn ->
          account_id
          |> url()
          |> mockable(GmbApi, by: GmbApiMock).get(
            headers(token)
          )
        end,
        @retry_options
      )

    parse(result, as: @as_struct)
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
