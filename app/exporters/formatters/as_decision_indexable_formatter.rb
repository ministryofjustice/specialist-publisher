require "formatters/abstract_specialist_document_indexable_formatter"

class AsDecisionIndexableFormatter < AbstractSpecialistDocumentIndexableFormatter
  def type
    "as_decision"
  end

private
  def extra_attributes
    {
    }
  end

  def organisation_slugs
    ["first-tier-tribunal-asylum-support"]
  end
end
