if Rails.env.production?
  Rails.application.config.middleware.insert_before(Rack::Runtime, Rack::Rewrite) do
    r301 %r{.*}, 'http://www.docrystal.org$&', if: proc { |rack_env|
      rack_env['SERVER_NAME'] != 'www.docrystal.org'
    }
  end
end
