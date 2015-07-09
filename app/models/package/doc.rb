class Package::Doc < ActiveRecord::Base
  belongs_to :package

  validates :package, presence: true
  validates :name, uniqueness: { scope: :package_id, allow_nil: true }
  validates :sha, presence: true, uniqueness: { scope: %i(package_id name) }

  after_initialize :detect_sha_by_branch
  after_initialize :detect_sha_by_tag
  after_initialize :detect_sha_by_commit
  after_save :kick_generate_job

  def path
    [package.path, name? ? name : sha].join('/')
  end

  def generated?
    generated_at?
  end

  private

  def detect_sha_by_branch
    return if sha || !package || !name

    self.sha = Octokit.branch(package.github_repo_name, name).commit.sha
  rescue Octokit::NotFound
  end

  def detect_sha_by_tag
    return if sha || !package || !name

    tags = Octokit.tags(package.github_repo_name)

    tags.each do |tag|
      if tag.name == name
        self.sha = tag.commit.sha
        break
      end
    end
  rescue Octokit::NotFound
  end

  def detect_sha_by_commit
    return if sha || !package || !name

    self.sha = Octokit.commit(package.github_repo_name, name).sha
    self.name = sha
  rescue Octokit::NotFound
  end

  def kick_generate_job
    CrystalDocJob.perform_later(id)
  end
end
