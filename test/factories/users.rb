Factory.define :user do |u|
  u.username 'test.user@uscm.org'
  u.plain_password 'asAfasfsd'
  u.plain_password_confirmation 'asAfasfsd'
  u.secret_question 'asdfsad'
  u.secret_answer 'asdfdasf'
end

Factory.define :josh_user, :parent => :user do |u|
  u.username 'josh.starcher@uscm.org'
  u.globallyUniqueID 'F167605D-94A4-7121-2A58-8D0F2CA6E026'
end

