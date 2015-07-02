require "formatters/abstract_specialist_document_indexable_formatter"

class EatDecisionIndexableFormatter < AbstractSpecialistDocumentIndexableFormatter
  def type
    "eat_decision"
  end

private
  def extra_attributes
    {
    }
  end

  def organisation_slugs
    ["employment-appeal-tribunal"]
  end
end
