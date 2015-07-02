require "formatters/eat_decision_artefact_formatter"
require "formatters/eat_decision_indexable_formatter"
require "markdown_attachment_processor"

class EatDecisionObserversRegistry < AbstractSpecialistDocumentObserversRegistry

private
  def finder_schema
    SpecialistPublisherWiring.get(:eat_decision_finder_schema)
  end

  def format_document_as_artefact(document)
    EatDecisionArtefactFormatter.new(document)
  end

  def format_document_for_indexing(document)
    EatDecisionIndexableFormatter.new(
      MarkdownAttachmentProcessor.new(document)
    )
  end

end
