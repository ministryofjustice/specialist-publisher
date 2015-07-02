require "formatters/abstract_artefact_formatter"

class FttDecisionArtefactFormatter < AbstractArtefactFormatter

  def state
    state_mapping.fetch(entity.publication_state)
  end

  def kind
    "ftt_decision"
  end

  def rendering_app
    "specialist-frontend"
  end

  def organisation_slugs
    ["first-tier-tribunal-tax"]
  end
end
