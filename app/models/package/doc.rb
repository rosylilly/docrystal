class Package::Doc < ActiveRecord::Base
  belongs_to :package, touch: true

  validates :package, presence: true
  validates :name, presence: true, uniqueness: { scope: :package_id, allow_nil: true }
  validates :sha, presence: true, uniqueness: { scope: %i(package_id name) }

  after_initialize :detect_sha_by_branch
  after_initialize :detect_sha_by_tag
  after_initialize :detect_sha_by_commit
  after_save :kick_generate_job

  def self.bucket_name
    @bucket_name ||= ENV['AWS_S3_BUCKET']
  end

  def path
    package.path.join(name? ? name : sha)
  end

  def s3_prefix
    package.path.join(sha)
  end

  def generated?
    self.class.where(sha: sha).where.not(generated_at: nil).exists?
  end

  def save_doc_file(name, body)
    Docrystal.s3.put_object(
      acl: 'private',
      bucket: self.class.bucket_name,
      content_type: MIME::Types.type_for(name).first.content_type,
      key: s3_prefix.join(name).to_s,
      body: body
    )
  end

  def get_doc_file(name, &block)
    Docrystal.s3.get_object({
                              bucket: self.class.bucket_name,
                              key: s3_prefix.join(name).to_s
                            }, &block)
  end

  def update_by_github
    if name != sha
      self.sha = nil
      detect_sha_by_branch
      detect_sha_by_tag
      save
    end
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
    CrystalDocJob.perform_later(id) unless generated?
  end
end
