class PagesController < ApplicationController
  def root(q = nil)
    if q
      @packages = Package.search(q).records
    else
      @packages = Package.order(updated_at: :desc).limit(20)
    end
  end
end
