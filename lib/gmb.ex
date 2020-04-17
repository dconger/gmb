defmodule Gmb do
  @moduledoc """
  Module for Google My Business Api v4.
  """

  import Gmb.Helpers
  import Mockery.Macro

  def parse(data, as: a_struct) do
    data
    |> underscore_keys()
    |> atomize_keys()
    |> transform(%{
      keys: :atoms!,
      as: a_struct
    })
  end
end
