defmodule Gmb.Api.LocationTest do
  use ExUnit.Case, async: false

  alias Gmb.Api
  alias Gmb.Api.Location

  import Mockery
  import Mockery.Assertions

  describe "fetch/2" do
    test "will correctly parse successfull call to GMB api" do
      mock(
        Api,
        [get: 2],
        {:ok, %HTTPoison.Response{body: %{"locations" => [%{"name" => "location-1"}]}, status_code: 200}}
      )

      {:ok, %Gmb.LocationsList{} = result} = Location.fetch("1", "fake-access-token")

      assert false
    end

    test "will retry when the client returns a 400 HTTP error" do
      mock(
        Api,
        [get: 2],
        {:ok, %HTTPoison.Response{body: "", status_code: 400}}
      )

      result = Location.fetch("1", "fake-access-token")

      assert_called(
        Api,
        :get,
        [
          "https://mybusiness.googleapis.com/v4/accounts/1/locations",
          [{"Authorization", "Bearer fake-access-token"}, {"Accept", "application/json"}]
        ],
        3
      )
    end
  end
end
