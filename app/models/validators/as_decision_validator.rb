require_relative 'tribunal_decision_validator'

class AsDecisionValidator < TribunalDecisionValidator

  validates :judges, presence: true

end
