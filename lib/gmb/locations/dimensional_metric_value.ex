defmodule Gmb.DimensionalMetricValue do
  @moduledoc """
  A value for a single metric with a given time dimension.

  See [DimensionalMetricValue](https://developers.google.com/my-business/reference/rest/v4/MetricValue#dimensionalmetricvalue)
  """

  @type t :: %__MODULE__{
          metric_option: String.t(),
          time_dimension: Gmb.TimeDimension.t() | nil,
          value: String.t()
        }

  defstruct [
    :metric_option,
    :time_dimension,
    :value
  ]
end
