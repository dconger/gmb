defmodule Gmb.MetricValue do
  @moduledoc """
  A value for a single Metric from a starting time.

  See [MetricValue](https://developers.google.com/my-business/reference/rest/v4/MetricValue)
  """

  @type t :: %__MODULE__{
          metric: String.t(),
          total_value: Gmb.DimensionalMetricValue.t() | nil,
          dimensional_values: list(Gmb.DimensionalMetricValue.t())
        }

  defstruct [
    :metric,
    :total_value,
    :dimensional_values
  ]
end
