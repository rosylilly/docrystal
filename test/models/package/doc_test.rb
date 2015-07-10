require "test_helper"

describe Package::Doc do
  use_vcr('octokit')

  let(:power_assert_url) { 'https://github.com/rosylilly/power_assert.cr' }
  let(:package) { Package.new(url: power_assert_url) }
  let(:doc) { Package::Doc.new(package: package, name: 'master') }

  describe '#sha' do
    it 'auto detected by branch' do
      assert doc.sha == '5f5b591a44bcb9cb1e29d0dfd4f02ec7afcc7fa9'
    end

    it 'auto detected by tag' do
      doc = Package::Doc.new(package: package, name: 'v0.2.0')

      assert doc.sha == '5f5b591a44bcb9cb1e29d0dfd4f02ec7afcc7fa9'
    end

    it 'auto detected by commit' do
      doc = Package::Doc.new(package: package, name: '5f5b591a44bcb9cb1e29d0dfd4f02ec7afcc7fa9')

      assert doc.sha == '5f5b591a44bcb9cb1e29d0dfd4f02ec7afcc7fa9'
      assert doc.name == doc.sha
    end

    it 'do not detect not found branch' do
      doc = Package::Doc.new(package: package, name: 'not_found')

      assert doc.sha.nil?
    end
  end
end
