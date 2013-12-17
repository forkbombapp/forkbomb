def mock_login(email)
  OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      :provider => 'github',
      :uid => '123456',
      :info => {
        :nickname => 'test_user',
        :email => email
      },
      :credentials => {
        :token => "fake-token-goes-here",
        :expires => false
      },
      :extra => {
        :raw_info => {
          :login => @github_username,
          :id => '123456',
          :name => "Mock Github user"
        }
      }
    })
end