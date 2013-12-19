
Devise.setup do |config|

  config.secret_key = '44de08ee65c11353602b282e6da1eb7ce1667e4add6b474cb3a59b0c1de3d602818d7420bbd6072a7c1fc3c3496d3f6e4928e814f439d9c80cfc499e87fddd04'
  config.mailer_sender = 'hello@forkbomb.io'
  
  require 'devise/orm/active_record'
  require 'omniauth-github'

  config.case_insensitive_keys = [ :email ]
  config.strip_whitespace_keys = [ :email ]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 10
  config.reconfirmable = true
  config.password_length = 8..128
  config.reset_password_within = 6.hours
  config.sign_out_via = :get

  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE if Rails.env.development? 
  config.omniauth :github, ENV['FORKBOMB_GITHUB_CLIENT_ID'], ENV['FORKBOMB_GITHUB_CLIENT_SECRET'], :scope => ''  
end
