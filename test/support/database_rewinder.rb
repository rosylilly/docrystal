DatabaseRewinder.clean_all

class ActiveSupport::TestCase
  after do
    DatabaseRewinder.clean
  end
end
