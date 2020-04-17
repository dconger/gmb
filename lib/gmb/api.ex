defmodule Gmb.Api do
  @moduledoc """
  Module for Google My Business Api v4.
  """
  use HTTPoison.Base

  alias Gmb.Errors.ResponseParseError

  require Logger

  def host, do: Application.get_env(:gmb, :api_host)

  def process_request_url(url), do: host() <> url

  def process_request_body(""), do: ""

  def process_request_body(body) do
    Jason.encode!(body)
  end

  def process_request_headers(headers), do: [{"content-type", "application/json"} | headers]

  def process_response_body(""), do: ""

  def process_response_body(body) do
    body
    |> Jason.decode()
    |> case do
      {:ok, response} ->
        {:ok, response}

      {:error, _error} ->
        raise ResponseParseError,
          message: "Attempted to parse the following response body:\n#{body}"
    end
  end

  def process_response_headers(headers), do: Map.new(headers)
end
