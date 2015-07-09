require "test_helper"

describe Package do
  let(:power_assert_url) { 'https://github.com/rosylilly/power_assert.cr' }
  let(:package) { Package.new(url: power_assert_url) }

  describe '.attributes_by_url' do
    it 'generate attributes by url' do
      attrs = Package.attributes_by_url(power_assert_url)

      assert { attrs[:hosting] == 'github' }
      assert { attrs[:owner] == 'rosylilly' }
      assert { attrs[:repo] == 'power_assert.cr' }
    end
  end

  describe '#set_hosting_and_owner_and_repo_by_url' do
    it 'auto set attributes' do
      assert { package.hosting == 'github' }
      assert { package.owner == 'rosylilly' }
      assert { package.repo == 'power_assert.cr' }
    end
  end
end
