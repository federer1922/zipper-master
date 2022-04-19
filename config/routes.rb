# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: 'attachments#index'

  resources :attachments, only: %i[new create]
end
