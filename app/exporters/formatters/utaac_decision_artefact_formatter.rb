require "formatters/abstract_artefact_formatter"

class UtaacDecisionArtefactFormatter < AbstractArtefactFormatter

  def state
    state_mapping.fetch(entity.publication_state)
  end

  def kind
    "utaac_decision"
  end

  def rendering_app
    "specialist-frontend"
  end

  def organisation_slugs
    ["upper-tribunal-administrative-appeals-chamber"]
  end
end
