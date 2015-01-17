Rails.application.config.middleware.use OmniAuth::Builder do
  # The following is for facebook
  provider :facebook, '1524911961126639', '417436ce145e623b467fc2d0c3de3422'
  # If you want to also configure for additional login services, they would be configured here.
end