ExUnit.start()

defmodule Helpers do
  @fixture_path "./test/fixtures/"

  def load_fixture(filename) do
    (@fixture_path <> filename) |> File.read!() |> Poison.decode!()
  end
end
