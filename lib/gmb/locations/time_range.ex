defmodule Gmb.TimeRange do
  @moduledoc """
  A range of time. Data will be pulled over the range as a half-open inverval (that is, [startTime, endTime)).

  See [TimeRange](https://developers.google.com/my-business/reference/rest/v4/TimeRange)
  """

  @type t :: %__MODULE__{
          start_time: String.t(),
          end_time: String.t()
        }

  defstruct [
    :start_time,
    :end_time
  ]
end
