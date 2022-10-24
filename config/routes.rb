Rails.application.routes.draw do

  constraints(:id => /[^\/]+/) do
    resources :hosts do
      member do
        post 'cert_revoke'
      end
    end
  end

end