defmodule Gmb.LocationMetric do
  @moduledoc """
  A series of Metrics and BreakdownMetrics associated with a Location over some time range.

  See [LocationMetric](https://developers.google.com/my-business/reference/rest/v4/accounts.locations/reportInsights#locationmetrics)
  """

  @type t :: %__MODULE__{
          location_name: String.t(),
          time_zone: String.t(),
          metric_values: list(Gmb.MetricValue.t())
        }

  defstruct [
    :location_name,
    :time_zone,
    :metric_values
  ]
end
