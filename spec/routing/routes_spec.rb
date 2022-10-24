# frozen_string_literal: true

# rubocop: disable Style/StringHashKeys
RSpec.describe Rcmdr::Routing::Routes do
  describe 'instance methods' do
    it { is_expected.to respond_to :draw }

    describe '#draw' do
      context 'when no &block is given' do
        it 'raises an error' do
          expect { described_class.new.draw }.to raise_error Rcmdr::Errors::NoBlockError
        end
      end

      context 'when a &block is given' do
        subject(:routes) do
          described_class.new.draw do
            get '/get', to: 'controller#index', as: :list
            delete '/delete', to: 'controller#delete', as: :delete
            patch '/put', to: 'controller#patch', as: :patch
            post '/post', to: 'controller#post', as: :post
            put '/put', to: 'controller#put', as: :put
          end
        end

        let(:expected_routes) do
          empty_verbs_hash.merge(
            {
              get: { '/get' => { to: 'controller#index' } },
              delete: { '/delete' => { to: 'controller#delete' } },
              patch: { '/put' => { to: 'controller#patch' } },
              post: { '/post' => { to: 'controller#post' } },
              put: { '/put' => { to: 'controller#put' } }
            }
          )
        end

        it 'draws the routes' do
          expect(routes.routes).to match expected_routes
        end
      end

      describe '#draw' do
        subject(:routes) do
          described_class.new.draw do
            # root '/'

            resources :photos

            # get '/users', to: 'users#index', as: :users_list
            # get '/car/engines', to: 'cars_engines#index'
            # get '/cars/engines', to: 'cars_engines#index'
            # get '/truck/:id/edit', to: 'trucks#edit'
          end
        end

        let(:expected_routes) do
          {
            delete: {
              '/photos/:id' => {
                to: 'photos#destroy'
              }
            },
            get: {
              '/photos/:id/edit' => {
                to: 'photos#edit'
              },
              '/photos' => {
                to: 'photos#index'
              },
              '/photos/new' => {
                to: 'photos#new'
              },
              '/photos/:id' => {
                to: 'photos#show'
              }
            },
            post: {
              '/photos' => {
                to: 'photos#create'
              }
            },
            patch: {
              '/photos/:id' => {
                to: 'photos#update'
              }
            },
            put: {
              '/photos/:id' => {
                to: 'photos#update'
              }
            }
          }
        end

        let(:expected_paths) do
          {
            'photos_path' => '/photos/index',
            'new_photo_path' => '/photos/new',
            'edit_photo_path' => '/photos/:id/edit',
            'photo_path' => '/photos/:id'
          }
        end

        it 'draws the routes' do
          expect(routes.routes).to eq expected_routes
        end

        it 'generates the paths' do
          expect(routes.paths).to eq expected_paths
        end
      end
    end
  end
end
# rubocop: enable Style/StringHashKeys
