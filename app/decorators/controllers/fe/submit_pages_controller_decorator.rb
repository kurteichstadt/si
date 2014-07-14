Fe::SubmitPagesController.class_eval do
  skip_before_filter :cas_filter
  skip_before_filter :authentication_filter
end
