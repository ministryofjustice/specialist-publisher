require "document_metadata_decorator"

class FttDecision < DocumentMetadataDecorator
  set_extra_field_names [
    :judges,
    :category
  ]
end
