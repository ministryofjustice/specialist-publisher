require_relative 'tribunal_decision_validator'

class AsDecisionValidator < TribunalDecisionValidator

  validates :category, presence: true
  validates :judges, presence: true

end
