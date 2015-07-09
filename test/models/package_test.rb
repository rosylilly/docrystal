require "test_helper"

describe Package do
  use_vcr('octokit')

  let(:power_assert_url) { 'https://github.com/rosylilly/power_assert.cr' }
  let(:not_found_url) { 'https://github.com/example/not_found' }
  let(:package) { Package.new(url: power_assert_url) }

  describe '.attributes_by_url' do
    it 'generate attributes by url' do
      attrs = Package.attributes_by_url(power_assert_url)

      assert attrs[:hosting] == 'github'
      assert attrs[:owner] == 'rosylilly'
      assert attrs[:repo] == 'power_assert.cr'
    end
  end

  describe '#github_repository' do
    it 'returns github repository object' do
      assert package.github_repository.language == 'Crystal'
    end

    it 'do not save not found repository' do
      package = Package.new(url: not_found_url)

      assert package.invalid?
    end
  end

  describe '#default_branch' do
    it 'by github' do
      assert package.default_branch == 'master'
    end
  end

  describe '#set_hosting_and_owner_and_repo_by_url' do
    it 'auto set attributes' do
      assert package.hosting == 'github'
      assert package.owner == 'rosylilly'
      assert package.repo == 'power_assert.cr'
    end
  end
end
