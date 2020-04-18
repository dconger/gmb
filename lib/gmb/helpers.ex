defmodule Gmb.Helpers do
  @moduledoc """
  Functions to transform maps
  """

  @spec ok(any()) :: {:ok, any()}
  def ok(item), do: {:ok, item}
  
  @doc """
  Convert map to struct of some type
  """
  def map_to_struct(a_map, as: a_struct) do
    # Find the keys within the map
    keys = a_struct
      |> Map.keys()
      |> Enum.filter(fn x -> x != :__struct__ end)

    # Process map, checking for both string / atom keys
    processed_map =
     for key <- keys, into: %{} do
         value = Map.get(a_map, key) || Map.get(a_map, to_string(key))
         {key, value}
       end

    Map.merge(a_struct, processed_map)
  end

  def transform(value, options) when is_map(value) or is_list(value) do
    case Map.get(options, :as) do
      nil -> value
      as -> transform(value, Map.get(options, :keys), as, options)
    end
  end

  defp transform(value, keys, %{__struct__: _} = as, options) do
    transform_struct(value, keys, as, options)
  end

  defp transform(value, keys, as, options) when is_map(as) do
    transform_map(value, keys, as, options)
  end

  defp transform(value, keys, [as], options) do
    for v <- value, do: transform(v, keys, as, options)
  end

  defp transform(value, _keys, _as, _options) do
    value
  end

  defp transform_map(value, keys, as, options) do
    Enum.reduce(as, value, fn {key, as}, acc ->
      case Map.get(acc, key) do
        value when is_map(value) or is_list(value) ->
          Map.put(acc, key, transform(value, keys, as, options))

        _ ->
          acc
      end
    end)
  end

  defp transform_struct(value, keys, as, options)
       when keys in [:atoms, :atoms!] do
    as
    |> Map.from_struct()
    |> Map.merge(value)
    |> do_transform_struct(keys, as, options)
  end

  defp transform_struct(value, keys, as, options) do
    as
    |> Map.from_struct()
    |> Enum.reduce(%{}, fn {key, default}, acc ->
      Map.put(acc, key, Map.get(value, Atom.to_string(key), default))
    end)
    |> do_transform_struct(keys, as, options)
  end

  defp do_transform_struct(value, keys, as, options) do
    default = struct(as.__struct__)

    as
    |> Map.from_struct()
    |> Enum.reduce(%{}, fn {key, as}, acc ->
      new_value =
        case Map.fetch(value, key) do
          {:ok, ^as} when is_map(as) or is_list(as) ->
            Map.get(default, key)

          {:ok, value} when is_map(value) or is_list(value) ->
            transform(value, keys, as, options)

          {:ok, value} ->
            value

          :error ->
            Map.get(default, key)
        end

      Map.put(acc, key, new_value)
    end)
    |> Map.put(:__struct__, as.__struct__)
  end

  @doc """
  Convert map string camelCase keys to underscore_keys
  """
  def underscore_keys(nil), do: nil

  def underscore_keys(map = %{}) do
    map
    |> Enum.map(fn {k, v} -> {Macro.underscore(k), underscore_keys(v)} end)
    |> Enum.map(fn {k, v} -> {String.replace(k, "-", "_"), v} end)
    |> Enum.into(%{})
  end

  # Walk the list and atomize the keys of
  # of any map members
  def underscore_keys([head | rest]) do
    [underscore_keys(head) | underscore_keys(rest)]
  end

  def underscore_keys(not_a_map) do
    not_a_map
  end

  @doc """
  Convert map string keys to :atom keys
  """
  def atomize_keys(nil), do: nil

  # Structs don't do enumerable and anyway the keys are already
  # atoms
  def atomize_keys(struct = %{__struct__: _}) do
    struct
  end

  def atomize_keys(map = %{}) do
    map
    |> Enum.map(fn {k, v} -> {String.to_atom(k), atomize_keys(v)} end)
    |> Enum.into(%{})
  end

  # Walk the list and atomize the keys of
  # of any map members
  def atomize_keys([head | rest]) do
    [atomize_keys(head) | atomize_keys(rest)]
  end

  def atomize_keys(not_a_map) do
    not_a_map
  end

  @doc """
  Convert map atom keys to strings
  """
  def stringify_keys(nil), do: nil

  def stringify_keys(map = %{}) do
    map
    |> Enum.map(fn {k, v} -> {Atom.to_string(k), stringify_keys(v)} end)
    |> Enum.into(%{})
  end

  # Walk the list and stringify the keys of
  # of any map members
  def stringify_keys([head | rest]) do
    [stringify_keys(head) | stringify_keys(rest)]
  end

  def stringify_keys(not_a_map) do
    not_a_map
  end

  @doc """
  Deep merge two maps
  """
  def deep_merge(left, right) do
    Map.merge(left, right, &deep_resolve/3)
  end

  # Key exists in both maps, and both values are maps as well.
  # These can be merged recursively.
  defp deep_resolve(_key, left = %{}, right = %{}) do
    deep_merge(left, right)
  end

  # Key exists in both maps, but at least one of the values is
  # NOT a map. We fall back to standard merge behavior, preferring
  # the value on the right.
  defp deep_resolve(_key, _left, right) do
    right
  end
end
