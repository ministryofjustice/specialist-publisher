require "formatters/abstract_specialist_document_indexable_formatter"

class UtaacDecisionIndexableFormatter < AbstractSpecialistDocumentIndexableFormatter
  def type
    "utaac_decision"
  end

private
  def extra_attributes
    {
    }
  end

  def organisation_slugs
    ["upper-tribunal-administrative-appeals-chamber"]
  end
end
