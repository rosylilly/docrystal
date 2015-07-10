class PagesController < ApplicationController
  def root(q = nil)
    if !q.nil? && q.present?
      @packages = Package.search(query: { match: { path: q } }).records
    else
      @packages = Package.order(updated_at: :desc).limit(20)
    end
  end
end
