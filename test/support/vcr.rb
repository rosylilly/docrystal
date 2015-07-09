VCR.configure do |c|
  c.cassette_library_dir = 'test/fixtures/vcr'
  c.hook_into :webmock
  c.default_cassette_options = { record: :new_episodes }
end

module ActiveSupport::TestCase::VCR
  extend ActiveSupport::Concern

  module ClassMethods
    def use_vcr(name)
      class_eval(<<-EOC)
        around do |tests|
          use_vcr(name, &tests)
        end
      EOC
    end
  end

  def use_vcr(name, &block)
    VCR.use_cassette(name, &block)
  end
end

ActiveSupport::TestCase.__send__(:include, ActiveSupport::TestCase::VCR)
