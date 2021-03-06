defmodule Gmb.Location do
  @moduledoc """
  A location. See the help center article for a detailed description of these fields, or the category endpoint for a list of valid business categories.

  See [Location](https://developers.google.com/my-business/reference/rest/v4/accounts.locations#Location)
  """

  @type t :: %__MODULE__{
    name: String.t(),
    language_code: String.t(),
    store_code: String.t(),
    location_name: String.t(),
    primary_phone: String.t(),
    additional_phones: list(String.t()),
    address: map(),
    primary_category: map(),
    additional_categories: list(map()),
    website_url: String.t(),
    regular_hours: map(),
    labels: list(String.t()),
    ad_words_location_extensions: map(),
    latlng: map(),
    open_info: map(),
    location_state: map(),
    attributes: list(map()),
    metadata: map(),
    price_lists: list(map()),
    profile: map(),
    relationship_data: map()
  }


  defstruct [
    :name,
    :language_code,
    :store_code,
    :location_name,
    :primary_phone,
    :additional_phones,
    :address,
    :primary_category,
    :additional_categories,
    :website_url,
    :regular_hours,
    :labels,
    :ad_words_location_extensions,
    :latlng,
    :open_info,
    :location_state,
    :attributes,
    :metadata,
    :price_lists,
    :profile,
    :relationship_data
  ]
end
