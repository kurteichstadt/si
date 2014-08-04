GATEWAY = ActiveMerchant::Billing::AuthorizeNetGateway.new(
 :login => Rails.application.secrets.merchant_login,
 :password => Rails.application.secrets.merchant_password
) unless defined? GATEWAY

unless Rails.env.production?
  ActiveMerchant::Billing::AuthorizeNetGateway.live_url = "https://test.authorize.net/gateway/transact.dll"
end

