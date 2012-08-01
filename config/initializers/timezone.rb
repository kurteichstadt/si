require 'rack/contrib'
Si::Application.config.middleware.use Rack::Locale
Si::Application.config.middleware.use Rack::TimeZone