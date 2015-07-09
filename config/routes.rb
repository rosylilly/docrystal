Rails.application.routes.draw do
  constraints DocsController::CONSTRAINTS do
    get ':hosting/:owner/:repo' => 'docs#repository'
    get ':hosting/:owner/:repo/:sha' => 'docs#show'
  end

  if Rails.env.development?
    require 'sidekiq/web'

    mount Sidekiq::Web => '/sidekiq'
  end
end
