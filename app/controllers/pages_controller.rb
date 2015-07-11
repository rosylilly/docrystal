class PagesController < ApplicationController
  def root(q = nil)
    if !q.nil? && q.present?
      @packages = Package.search(query: { match: { path: q } }).records
    else
      @packages = Package.order(updated_at: :desc).limit(20)
    end
  end

  def badge
    expires_in 1.month, public: true

    style = (%w(round plastic).include?(params[:style]) ? params[:style].to_s : nil)

    respond_to do |format|
      format.svg { render "badge#{ style ? "-#{style}" : '' }" }
      format.html
    end
  end
end
