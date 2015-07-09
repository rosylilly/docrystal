class Package < ActiveRecord::Base
  HOSTINGS = %w(github)

  GITHUB_URL_REGEXP = %r{https?://github\.com/(?<owner>[a-zA-Z0-9](?:[a-zA-Z0-9-]+))/(?<repo>[^/]+)(?:$|/)}

  attr_accessor :url

  validates :hosting, presence: true, inclusion: { in: HOSTINGS }
  validates :owner, presence: true
  validates :repo, presence: true, uniqueness: { scope: %i(hosting owner) }
  validates :github_repository, presence: true

  after_initialize :set_hosting_and_owner_and_repo_by_url

  def self.attributes_by_url(url)
    match = GITHUB_URL_REGEXP.match(url)
    return {} unless match

    {
      hosting: 'github',
      owner: match[:owner],
      repo: match[:repo]
    }
  end

  def github_repo_name
    "#{owner}/#{repo}"
  end

  def github_repository
    Octokit.repo(github_repo_name)
  rescue Octokit::NotFound
    nil
  end

  def default_branch
    github_repository.default_branch
  end

  private

  def set_hosting_and_owner_and_repo_by_url
    attrs = self.class.attributes_by_url(url)
    return if attrs.empty?

    attrs.each do |k, v|
      write_attribute(k, v)
    end
  end
end
