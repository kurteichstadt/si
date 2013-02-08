class Payment < ActiveRecord::Base
  set_table_name "#{TABLE_NAME_PREFIX}payments" 

  attr_accessor :first_name, :last_name, :address, :city, :state, :zip, :card_number,
                :expiration_month, :expiration_year, :security_code, :staff_first, :staff_last, :card_type

  scope :non_denied, where("(status <> 'Denied' AND status <> 'Errored') OR status is null")
  
  belongs_to :apply
  
  after_save :check_app_complete
  
  def validate
    if credit?
      errors.add_on_empty([:first_name, :last_name, :address, :city, :state, :zip, :card_number,
                :expiration_month, :expiration_year, :security_code])
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
    card =  ActiveMerchant::Billing::CreditCard.new(:number => card_number)
    card.valid?
    card.type
  end
end
