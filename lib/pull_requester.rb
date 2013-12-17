class PullRequester

  def self.perform(user, repo_name)
    # get repository details
    repo = Rails.application.github.repos.get user, repo_name

    if repo.parent
      branch = repo.default_branch
      upstream_owner = repo.parent.owner.login
      upstream_branch = repo.parent.default_branch

      begin
        Rails.application.github.pulls.create(user, repo_name,
          title: 'Upstream changes',
          body: 'Automatically opened by http://forkbomb.io',
          head: "#{upstream_owner}:#{upstream_branch}",
          base: branch
        )
      rescue Github::Error::UnprocessableEntity => ex
        # absorb errors caused by already-open PRs or zero-size PRs
        raise unless ex.message.include?("A pull request already exists") || ex.message.include?("No commits between")
      end

    end

  end

end