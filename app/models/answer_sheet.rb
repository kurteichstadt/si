# load in original Answer model
require_dependency Rails.root.to_s + "/vendor/plugins/questionnaire_engine/app/models/answer_sheet"

class AnswerSheet < ActiveRecord::Base
  self.abstract_class = true # To fix rails 3.2 bug: https://github.com/rails/rails/issues/4578
end