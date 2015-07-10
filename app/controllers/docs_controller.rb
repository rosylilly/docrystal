class DocsController < ApplicationController
  HOSTING_REGEXP = /#{Package::HOSTINGS.map {|h| Regexp.escape(h) }.join('|')}/x
  OWNER_REGEXP = Package::GITHUB_USER_NAME_REGEXP
  REPO_REGEXP = Package::GITHUB_REPO_NAME_REGEXP
  SHA_REGEXP = %r{[^/]+}
  FILE_REGEXP = %r{.+}

  CONSTRAINTS = {
    hosting: HOSTING_REGEXP,
    owner: OWNER_REGEXP,
    repo: REPO_REGEXP,
    sha: SHA_REGEXP,
    file: FILE_REGEXP
  }

  def repository(hosting, owner, repo)
    @package = Package.find_or_create_by!(hosting: hosting, owner: owner, repo: repo)

    branch = @package.branch_by(request.referer)

    redirect_to '/' + [@package.path, branch].join('/')
  end

  def show(hosting, owner, repo, sha)
    @package = Package.find_or_create_by!(hosting: hosting, owner: owner, repo: repo)
    @doc = @package.docs.find_or_create_by(name: sha)

    @doc.update_by_github

    unless @doc.generated?
      render :wait
    else
      redirect_to '/' + @doc.path.join('index.html').to_s
    end
  end

  def file_serve(hosting, owner, repo, sha, file)
    @package = Package.find_by!(hosting: hosting, owner: owner, repo: repo)
    @doc = @package.docs.find_by!(name: sha)

    @file = @doc.get_doc_file(file)

    if stale?(etag: @file.etag, last_modified: @file.last_modified, public: true)
      render s3: @file
    end
  end
end
