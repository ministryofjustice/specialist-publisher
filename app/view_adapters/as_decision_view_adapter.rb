class AsDecisionViewAdapter < TribunalDecisionViewAdapter

  define_attributes [
    :category,
    :decision_date,
    :judges,
    :landmark,
    :reference_number,
  ]

end
