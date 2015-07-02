require "formatters/as_decision_artefact_formatter"
require "formatters/as_decision_indexable_formatter"
require "markdown_attachment_processor"

class AsDecisionObserversRegistry < AbstractSpecialistDocumentObserversRegistry

private
  def finder_schema
    SpecialistPublisherWiring.get(:as_decision_finder_schema)
  end

  def format_document_as_artefact(document)
    AsDecisionArtefactFormatter.new(document)
  end

  def format_document_for_indexing(document)
    AsDecisionIndexableFormatter.new(
      MarkdownAttachmentProcessor.new(document)
    )
  end

end
