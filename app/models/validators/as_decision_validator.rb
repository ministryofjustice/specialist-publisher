require_relative 'tribunal_decision_validator'

class AsDecisionValidator < TribunalDecisionValidator

  validates :category, presence: true
  validates :decision_date, presence: true
  validates :judges, presence: true
  validates :landmark, presence: true
  validates :reference_number, presence: true

end
