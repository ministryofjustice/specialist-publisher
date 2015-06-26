require "document_metadata_decorator"

class UtiacDecision < DocumentMetadataDecorator
  set_extra_field_names [
    :country,
    # :country_guidance,
    :judges,
    :promulgation_date,
    :publication_date,
    # :reported,
  ]
end
