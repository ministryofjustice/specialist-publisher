require "document_metadata_decorator"

class AsDecision < DocumentMetadataDecorator
  set_extra_field_names [
    :judges,
  ]
end
