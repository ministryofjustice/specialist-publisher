require "formatters/abstract_specialist_document_indexable_formatter"

class AsDecisionIndexableFormatter < AbstractSpecialistDocumentIndexableFormatter
  def type
    "as_decision"
  end

private
  def extra_attributes
    {
      category: entity.category,
      decision_date: entity.decision_date,
      judges: entity.judges,
      landmark: entity.landmark,
      reference_number: entity.reference_number,
    }
  end

  def organisation_slugs
    ["first-tier-tribunal-asylum-support"]
  end
end
