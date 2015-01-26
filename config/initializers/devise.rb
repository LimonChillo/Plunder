require 'omniauth-facebook'
Devise.setup do |config|
  config.secret_key = ENV["device_secret_key"]
  config.mailer_sender = 'register@plunder.club'
  require 'devise/orm/active_record'
  config.case_insensitive_keys = [ :email ]
  config.strip_whitespace_keys = [ :email ]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 10
  config.reconfirmable = true
  config.expire_all_remember_me_on_sign_out = true
  config.password_length = 8..128
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete
  config.omniauth :facebook, '366266453554861', ENV["facebook_secret"]
end