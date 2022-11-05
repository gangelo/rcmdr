# frozen_string_literal: true

RSpec.describe Rcmdr::Application do
  subject(:application) { described_class.new }

  describe 'instance methods' do
    it { is_expected.to respond_to :routes }

    describe '#routes' do
      subject(:routes) { application.routes }

      before do
        routes.draw do
          root 'home#index'

          resources :photos

          get '/profile', to: 'profiles#show', as: 'profile_path'
          get '/profile/edit', to: 'profiles#edit', as: 'edit_profile_path'
          put '/profile/update', to: 'profiles#update', as: 'update_profile_path'
        end
      end

      xit 'does something awesome'
    end
  end
end
