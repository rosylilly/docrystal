class Package < ActiveRecord::Base
  include Searchable

  HOSTINGS = %w(github.com)
  GITHUB_USER_NAME_REGEXP = %r{[a-zA-Z0-9](?:[a-zA-Z0-9-]+)}
  GITHUB_REPO_NAME_REGEXP = %r{[^/]+}
  GITHUB_URL_REGEXP = %r{https?://github\.com/(?<owner>#{GITHUB_USER_NAME_REGEXP})/(?<repo>#{GITHUB_REPO_NAME_REGEXP})(?:$|/)}x

  attr_accessor :url

  has_many :docs, class_name: 'Package::Doc'

  validates :hosting, presence: true, inclusion: { in: HOSTINGS }
  validates :owner, presence: true
  validates :repo, presence: true, uniqueness: { scope: %i(hosting owner) }
  validates :github_repository, presence: true

  after_initialize :set_hosting_and_owner_and_repo_by_url
  after_create :kick_import_package

  def self.attributes_by_url(url)
    match = GITHUB_URL_REGEXP.match(url)
    return {} unless match

    {
      hosting: 'github.com',
      owner: match[:owner],
      repo: match[:repo]
    }
  end

  def path
    Pathname.new([hosting, owner, repo].join('/'))
  end

  def github_repo_name
    "#{owner}/#{repo}"
  end

  def github_repository
    Octokit.repository(github_repo_name)
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

  def kick_import_package
    ImportPackageJob.perfom_later
  end
end
