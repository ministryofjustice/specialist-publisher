require "formatters/et_decision_artefact_formatter"
require "formatters/et_decision_indexable_formatter"
require "markdown_attachment_processor"

class EtDecisionObserversRegistry < AbstractSpecialistDocumentObserversRegistry

private
  def finder_schema
    SpecialistPublisherWiring.get(:et_decision_finder_schema)
  end

  def format_document_as_artefact(document)
    EtDecisionArtefactFormatter.new(document)
  end

  def format_document_for_indexing(document)
    EtDecisionIndexableFormatter.new(
      MarkdownAttachmentProcessor.new(document)
    )
  end

end
