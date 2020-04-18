defmodule Gmb.LocationsList do
  @moduledoc """
  See [LocationsList](https://developers.google.com/my-business/reference/rest/v4/accounts.locations/list)
  """

  @type t :: %__MODULE__{
          locations: list(Gmb.Location.t()),
          next_page_token: String.t(),
          total_size: integer()
        }

  defstruct [
    :locations,
    :next_page_token,
    :total_size
  ]
end
