require "formatters/utaac_decision_artefact_formatter"
require "formatters/utaac_decision_indexable_formatter"
require "markdown_attachment_processor"

class UtaacDecisionObserversRegistry < AbstractSpecialistDocumentObserversRegistry

private
  def finder_schema
    SpecialistPublisherWiring.get(:utaac_decision_finder_schema)
  end

  def format_document_as_artefact(document)
    UtaacDecisionArtefactFormatter.new(document)
  end

  def format_document_for_indexing(document)
    UtaacDecisionIndexableFormatter.new(
      MarkdownAttachmentProcessor.new(document)
    )
  end

end
