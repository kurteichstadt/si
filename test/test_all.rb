require 'test/unit'

#Unit tests.
Dir[File.dirname(__FILE__) + '/unit/*.rb'].each do |file|
  require file
end

#Functional tests.
Dir[File.dirname(__FILE__) + '/functional/*.rb'].each do |file|
  require file
end