defmodule Gmb.TimeDimension do
  @moduledoc """
  The dimension for which data is divided over.

  See [TimeDimension](https://developers.google.com/my-business/reference/rest/v4/MetricValue#dimensionalmetricvalue)
  """

  @type t :: %__MODULE__{
          day_of_week: String.t(),
          time_of_day: Gmb.TimeOfDay.t() | nil,
          time_range: Gmb.TimeRange.t() | nil
        }

  defstruct [
    :day_of_week,
    :time_of_day,
    :time_range
  ]
end
