class UtiacDecisionValidator < TribunalDecisionValidator

  # validates :country, presence: true
  # validates :country_guidance, presence: true
  validates :judges, presence: true

  validates :promulgation_date, presence: true, date: true
  # validates :reported, presence: true, date: true
end
