require "formatters/abstract_specialist_document_indexable_formatter"

class EtDecisionIndexableFormatter < AbstractSpecialistDocumentIndexableFormatter
  def type
    "et_decision"
  end

private
  def extra_attributes
    {
    }
  end

  def organisation_slugs
    ["employment-tribunal"]
  end
end
