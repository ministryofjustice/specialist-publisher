require "formatters/abstract_specialist_document_indexable_formatter"

class FttDecisionIndexableFormatter < AbstractSpecialistDocumentIndexableFormatter
  def type
    "ftt_decision"
  end

private
  def extra_attributes
    {
      judges: entity.judges,
      category: entity.category
    }
  end

  def organisation_slugs
    ["first-tier-tribunal-tax"]
  end
end
