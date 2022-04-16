# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'attachments#index'

  resources :attachments, only: %i[new create]
end
