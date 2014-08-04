Fe::Element.class_eval do
  def self.max_label_length
    @@max_label_length = 128
  end
end
