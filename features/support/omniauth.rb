def mock_login(username)
  OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      :provider => 'github',
      :uid => '123456',
      :info => {
        :nickname => username,
      },
      :credentials => {
        :token => "fake-token-goes-here",
        :expires => false
      },
      :extra => {
        :raw_info => {
          :login => username,
          :id => '123456',
          :name => "Mock Github user"
        }
      }
    })
end