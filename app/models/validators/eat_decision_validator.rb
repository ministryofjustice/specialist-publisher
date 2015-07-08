class EatDecisionValidator < TribunalDecisionValidator
  validates :judges, presence: true
end
