# ReferenceQuestion
# - a question that provides a fields to specify a reference

class PaymentQuestion < Question
  
  def response(app=nil)
    return Payment.new unless app
    app.payments || [Payment.new(:application_id => app.id) ]
  end
  
  def display_response(app=nil)
    response(app).to_s
  end
  
  def has_response?(answer_sheet = nil)
    if answer_sheet
      answer_sheet.payments.length > 0
    else
      false
    end
  end
  
end

