Factory.define :payment do |p|
  p.association   :apply
  p.payment_type  'Mail'
  p.amount        35.0
  p.status        'Pending'
end

Factory.define :staff_payment, :parent => :payment do |p|
  p.payment_type        'Staff'
  p.payment_account_no  '000559826'
end