Rails.application.config.tap do |config|
  config.event_tracker.mixpanel_key = ENV['MIXPANEL_KEY'] if ENV['MIXPANEL_KEY']
  config.event_tracker.google_analytics_key = ENV['GOOGLE_ANALYTICS_KEY'] if ENV['GOOGLE_ANALYTICS_KEY']
end
