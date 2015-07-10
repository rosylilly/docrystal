class ImportPackageJob < ActiveJob::Base
  queue_as :default

  def perform
    Package.import
  end
end
