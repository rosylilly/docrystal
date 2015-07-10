Rails.application.routes.draw do
  root to: 'pages#root'
  get 'badge' => 'pages#badge'

  constraints DocsController::CONSTRAINTS do
    get ':hosting/:owner/:repo' => 'docs#repository'
    get ':hosting/:owner/:repo/:sha' => 'docs#show'
    get ':hosting/:owner/:repo/:sha/:file' => 'docs#file_serve'
  end

  if Rails.env.development?
    require 'sidekiq/web'

    mount Sidekiq::Web => '/sidekiq'
  end
end
