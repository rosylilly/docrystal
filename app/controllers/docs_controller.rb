class DocsController < ApplicationController
  HOSTING_REGEXP = /#{Package::HOSTINGS.map {|h| Regexp.escape(h) }.join('|')}/x
  OWNER_REGEXP = Package::GITHUB_USER_NAME_REGEXP
  REPO_REGEXP = Package::GITHUB_REPO_NAME_REGEXP
  SHA_REGEXP = %r{[^/]+}

  CONSTRAINTS = {
    hosting: HOSTING_REGEXP,
    owner: OWNER_REGEXP,
    repo: REPO_REGEXP,
    sha: SHA_REGEXP
  }

  def repository(hosting, owner, repo)
    @package = Package.find_or_create_by!(hosting: hosting, owner: owner, repo: repo)

    redirect_to '/' + [@package.path, @package.default_branch].join('/')
  end

  def show(hosting, owner, repo, sha)
    @package = Package.find_or_create_by!(hosting: hosting, owner: owner, repo: repo)
    @doc = @package.docs.find_or_create_by(name: sha)

    unless @doc.generated?
      render :wait
    end
  end
end
