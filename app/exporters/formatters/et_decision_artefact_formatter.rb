require "formatters/abstract_artefact_formatter"

class EtDecisionArtefactFormatter < AbstractArtefactFormatter

  def state
    state_mapping.fetch(entity.publication_state)
  end

  def kind
    "et_decision"
  end

  def rendering_app
    "specialist-frontend"
  end

  def organisation_slugs
    ["employment-tribunal"]
  end
end
