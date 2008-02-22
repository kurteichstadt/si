class Payment < ActiveRecord::Base
  set_table_name "#{TABLE_NAME_PREFIX}payments"   # `references` is a reserved word in MySQL

  attr_accessor :first_name, :last_name, :address, :city, :state, :zip, :card_number,
                :expiration_month, :expiration_year, :staff_first, :staff_last, :card_type

  belongs_to :apply
  
  after_save :check_app_complete
  
  def validate
    if credit?
      errors.add_on_empty([:first_name, :last_name, :address, :city, :state, :zip, :card_number,
                :expiration_month, :expiration_year])
      errors.add(:card_number, "is invalid.") if get_card_type.nil?
    end
  end
  
  def check_app_complete
    if self.approved?
      self.apply.complete
    end
  end
  
  def credit?
    self.payment_type == 'Credit Card'
  end
  
  def staff?
    self.payment_type == 'Staff'
  end
  
  def approved?
    self.status == "Approved"
  end
  
  def approve!
    self.status = "Approved"
    self.save!
  end

  def get_card_type
    mc_regEx = /^5[1-5]/
    visa_regEx = /^4/
    amex_regEx = /^3(4|7)/
    disc_regEx = /^6(011|5)/
    
    if mc_regEx.match(self.card_number)
      return "master"
    elsif (visa_regEx.match(self.card_number)) 
      return "visa"
    elsif (amex_regEx.match(self.card_number)) 
      return "american_express"
    elsif (disc_regEx.match(self.card_number)) 
      return "discover"
    else 
      return nil
    end
  end
end
