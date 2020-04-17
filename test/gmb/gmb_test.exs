defmodule GmbTest do
  use ExUnit.Case

  @tag :current
  test "parse/1" do
    input = Helpers.load_fixture("location.reportInsights.json")

    as_struct = %Gmb.ReportInsight{
      location_metrics: [
        %Gmb.LocationMetric{
          metric_values: [%Gmb.MetricValue{
            dimensional_values: [%Gmb.DimensionalMetricValue{}]
          }]
        }
      ]
    }

    result = Gmb.parse(input, as: as_struct)

    expected = %Gmb.ReportInsight{
      location_metrics: [
        %Gmb.LocationMetric{
          location_name: "accounts/103644375082308816547/locations/15051991236423709474",
          time_zone: "America/New_York",
          metric_values: [
            %Gmb.MetricValue{
              metric: "",
              total_value: nil,
              dimensional_values: [
                %Gmb.DimensionalMetricValue{
                  metric_option: "",
                  time_dimension: %Gmb.TimeDimension{
                    time_range: %Gmb.TimeRange{
                      start_time: ""
                    }
                  },
                  value: ""
                }
              ]
            }
          ]
        }
      ]
    }

    assert expected == result
  end
end
