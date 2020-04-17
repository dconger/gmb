defmodule Gmb.TimeOfDay do
  @moduledoc """
  Represents a time of day. The date and time zone are either not significant or are specified elsewhere. An API may choose to allow leap seconds. Related types are google.type.Date and google.protobuf.Timestamp.

  See [TimeOfDay](https://developers.google.com/my-business/reference/rest/v4/accounts.locations.localPosts#timeofday)
  """

  @type t :: %__MODULE__{
          hours: integer,
          minutes: integer,
          seconds: integer,
          nanos: integer
        }

  defstruct [
    :hours,
    :minutes,
    :seconds,
    :nanos
  ]
end
