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
        {:error, %ResponseParseError{message: "Attempted to parse the following response body:\n#{body}"}}
    end
  end

  def process_response_headers(headers), do: Map.new(headers)

  @doc """
  Convert HTTP error codes to error tuples
  """
  def handle_response({:ok, %HTTPoison.Response{status_code: code} = response})
      when code >= 200 and code < 300 do
    {:ok, response}
  end

  def handle_response({:ok, %HTTPoison.Response{status_code: code} = response})
      when code >= 300 do
    Logger.error("HTTP Error. status_code: #{inspect(code)}")
    {:error, response}
  end

  def handle_response({:error, _} = response), do: response

  def handle_response({status, details}) do
    Logger.error("Unhandled HTTP Error. status: #{inspect(status)}. details: #{inspect(details)}")
    {:error, :unknown}
  end

  def handle_response(error) do
    Logger.error("Unhandled HTTP Error. response: #{inspect(error)}.")
    {:error, :unknown}
  end
end
