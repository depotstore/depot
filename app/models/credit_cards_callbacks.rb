class CreditCardsCallbacks

  #normalize_credit_card_number
  def before_validation(model)
    model.cc_number.gsub!(/[-\s]/, '') if model.cc_number
  end

end
