class PagesController < ApplicationController
  def root
    @packages = Package.order(updated_at: :desc).limit(20)
  end
end
