defmodule Gmb.Api.Token do
  @moduledoc false

  alias Gmb.Api, as: GmbApi
  alias Gmb.Errors.ResponseParseError
  alias Gmb.Types

  import Mockery.Macro

  @grant_type "refresh_token"

  @retry_options [
    attempts: 3,
    delay_time_ms: 100,
    delay_type: :constant,
    rescue_exceptions: [ResponseParseError]
  ]

  @spec fetch(Types.token()) :: {:ok | :error, any()}
  def fetch(refresh_token) do
    Mulligan.retry(
      fn ->
        url()
        |> mockable(GmbApi, by: GmbApiMock).post(
          fetch_body(refresh_token),
          headers()
        )
      end,
      @retry_options
    )
  end

  defp url, do: "https://www.googleapis.com/oauth2/v4/token"

  defp fetch_body(refresh_token) do
    %{
      client_id: Application.get_env(:gmb, :client_id),
      client_secret: Application.get_env(:gmb, :client_secret),
      grant_type: @grant_type,
      refresh_token: refresh_token
    }
  end

  defp headers, do:
    [
      {"Content-Type", "application/json"},
      {"Accept", "application/json"}
    ]
end
