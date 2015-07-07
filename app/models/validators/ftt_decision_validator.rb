class FttDecisionValidator < TribunalDecisionValidator
  validates :judges, presence: true
end
