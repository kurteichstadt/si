FactoryGirl.define do
  factory :character_reference do
    association   :apply
    association   :sleeve_sheet
    name          'Shanda Eickekberger'
    email         'Shanda.Eickelberger@uscm.org'
    phone         '894.395.4932'
    months_known  3
  end
end
