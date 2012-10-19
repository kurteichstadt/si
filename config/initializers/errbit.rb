Airbrake.configure do |config|
  config.api_key     = '5846f460f6100fde4cb1cc52d6b895d1'
  config.host        = 'errors.uscm.org'
  config.port        = 80
  config.secure      = config.port == 443
end