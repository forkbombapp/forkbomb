class Forkbomb::Application
  def github
    @github ||= Github.new :oauth_token => ENV['FORKBOMB_GITHUB_OAUTH_TOKEN']
  end
end