require "formatters/ftt_decision_artefact_formatter"
require "formatters/ftt_decision_indexable_formatter"
require "markdown_attachment_processor"

class FttDecisionObserversRegistry < AbstractSpecialistDocumentObserversRegistry

private
  def finder_schema
    SpecialistPublisherWiring.get(:ftt_decision_finder_schema)
  end

  def format_document_as_artefact(document)
    FttDecisionArtefactFormatter.new(document)
  end

  def format_document_for_indexing(document)
    FttDecisionIndexableFormatter.new(
      MarkdownAttachmentProcessor.new(document)
    )
  end

end
