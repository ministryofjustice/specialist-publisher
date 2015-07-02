require "formatters/abstract_artefact_formatter"

class AsDecisionArtefactFormatter < AbstractArtefactFormatter

  def state
    state_mapping.fetch(entity.publication_state)
  end

  def kind
    "as_decision"
  end

  def rendering_app
    "specialist-frontend"
  end

  def organisation_slugs
    ["first-tier-tribunal-asylum-support"]
  end
end
