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
              root: {},
              get: { '/get' => { to: 'controller#index' } },
              delete: { '/delete' => { to: 'controller#delete' } },
              patch: { '/put' => { to: 'controller#patch' } },
              post: { '/post' => { to: 'controller#post' } },
              put: { '/put' => { to: 'controller#put' } }
            }
          )
        end

        it 'draws the routes' do
          expect(routes.routes).to match_array expected_routes
        end
      end

      describe '#draw' do
        describe '#root' do
          subject(:routes) do
            described_class.new.draw do
              root 'home#index'
            end
          end

          let(:expected_routes) do
            {
              delete: {},
              get: {},
              patch: {},
              post: {},
              put: {},
              root: {
                '/' => {
                  to: 'home#index'
                }
              }
            }
          end

          let(:expected_paths) do
            {
              'root_path' => '/',
              'root_url' => 'rcmdr://app/'
            }
          end

          it_behaves_like 'the correct routes are drawn'
          it_behaves_like 'the correct paths are drawn'
        end

        describe '#resources' do
          subject(:routes) do
            described_class.new.draw do
              resources :photos
            end
          end

          let(:expected_routes) do
            {
              root: {},
              get: {
                '/photos/:id/edit' => { controller: 'PhotosController', action: :edit },
                '/photos' => { controller: 'PhotosController', action: :index },
                '/photos/new' => { controller: 'PhotosController', action: :new },
                '/photos/:id' => { controller: 'PhotosController', action: :show }
              },
              post: {
                '/photos' => { controller: 'PhotosController', action: :create }
              },
              put: {
                '/photos/:id' => { controller: 'PhotosController', action: :update }
              },
              patch: {
                '/photos/:id' => { controller: 'PhotosController', action: :update }
              },
              delete: {
                '/photos/:id' => { controller: 'PhotosController', action: :destroy }
              }
            }
          end

          let(:expected_paths) do
            {
              'photos_path' => '/photos',
              'photos_url' => 'rcmdr://app/photos',
              'photo_path' => '/photos/:id',
              'photo_url' => 'rcmdr://app/photos/:id',
              'edit_photo_path' => '/photos/:id/edit',
              'edit_photo_url' => 'rcmdr://app/photos/:id/edit',
              'new_photo_path' => '/photos/new',
              'new_photo_url' => 'rcmdr://app/photos/new'
            }
          end

          it_behaves_like 'the correct routes are drawn'
          it_behaves_like 'the correct paths are drawn'
        end

        describe '#resource' do
          subject(:routes) do
            described_class.new.draw do
              resource :photos
            end
          end

          let(:expected_routes) do
            {
              root: {},
              get: {
                '/photos/edit' => { controller: 'PhotosController', action: :edit },
                '/photos/new' => { controller: 'PhotosController', action: :new },
                '/photos' => { controller: 'PhotosController', action: :show }
              },
              post: {
                '/photos' => { controller: 'PhotosController', action: :create }
              },
              put: {
                '/photos' => { controller: 'PhotosController', action: :update }
              },
              patch: {
                '/photos' => { controller: 'PhotosController', action: :update }
              },
              delete: {
                '/photos' => { controller: 'PhotosController', action: :destroy }
              }
            }
          end

          let(:expected_paths) do
            {
              'photos_path' => '/photos',
              'photos_url' => 'rcmdr://app/photos',
              'photo_path' => '/photos',
              'photo_url' => 'rcmdr://app/photos',
              'edit_photo_path' => '/photos/edit',
              'edit_photo_url' => 'rcmdr://app/photos/edit',
              'new_photo_path' => '/photos/new',
              'new_photo_url' => 'rcmdr://app/photos/new'
            }
          end

          it_behaves_like 'the correct routes are drawn'
          it_behaves_like 'the correct paths are drawn'
        end
      end
    end
  end
end
# rubocop: enable Style/StringHashKeys
