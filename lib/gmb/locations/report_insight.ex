defmodule Gmb.ReportInsight do
  @moduledoc """
  See [ReportInsight](https://developers.google.com/my-business/reference/rest/v4/accounts.locations/reportInsights)
  """

  @type t :: %__MODULE__{
          location_metrics: list(Gmb.LocationMetric.t())
        }

  defstruct [
    :location_metrics
  ]
end
