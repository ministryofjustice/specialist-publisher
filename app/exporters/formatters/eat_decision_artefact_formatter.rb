require "formatters/abstract_artefact_formatter"

class EatDecisionArtefactFormatter < AbstractArtefactFormatter

  def state
    state_mapping.fetch(entity.publication_state)
  end

  def kind
    "eat_decision"
  end

  def rendering_app
    "specialist-frontend"
  end

  def organisation_slugs
    ["employment-appeal-tribunal"]
  end
end
