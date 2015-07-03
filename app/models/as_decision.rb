require "document_metadata_decorator"

class AsDecision < DocumentMetadataDecorator
  set_extra_field_names [
    :category,
    :decision_date,
    :judges,
    :landmark,
    :reference_number,
  ]
end
