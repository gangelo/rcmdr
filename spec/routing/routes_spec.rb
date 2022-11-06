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
            root 'home#index'
            get '/get', to: 'articles#index', as: :list
            delete '/delete', to: 'articles#delete', as: :delete
            patch '/put', to: 'articles#patch', as: :patch
            post '/post', to: 'articles#post', as: :post
            put '/put', to: 'articles#put', as: :put
          end
        end

        let(:expected_routes) do
          empty_verbs_hash.merge(
            {
              root: {
                '/' => {
                  controller: 'HomeController', action: 'index'
                }
              },
              get: {
                '/get' => {
                  controller: 'ArticlesController', action: 'index'
                }
              }, post: {
                '/post' => {
                  controller: 'ArticlesController', action: 'post'
                }
              }, put: {
                '/put' => {
                  controller: 'ArticlesController', action: 'put'
                }
              }, patch: {
                '/put' => {
                  controller: 'ArticlesController', action: 'patch'
                }
              }, delete: {
                '/delete' => {
                  controller: 'ArticlesController', action: 'delete'
                }
              }
            }
          )
        end

        it 'draws the routes' do
          expect(routes.routes).to match_array expected_routes
        end
      end

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
                action: 'index',
                controller: 'HomeController'
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

      describe '#namespace' do
        context 'with a single namespace' do
          subject(:routes) do
            described_class.new.draw do
              namespace :admin do
                resources :photos
              end
            end
          end

          let(:expected_routes) do
            {
              root: {},
              get: {
                '/admin/photos/:id/edit' => { controller: 'Admin::PhotosController', action: :edit },
                '/admin/photos' => { controller: 'Admin::PhotosController', action: :index },
                '/admin/photos/new' => { controller: 'Admin::PhotosController', action: :new },
                '/admin/photos/:id' => { controller: 'Admin::PhotosController', action: :show }
              },
              post: {
                '/admin/photos' => { controller: 'Admin::PhotosController', action: :create }
              },
              put: {
                '/admin/photos/:id' => { controller: 'Admin::PhotosController', action: :update }
              },
              patch: {
                '/admin/photos/:id' => { controller: 'Admin::PhotosController', action: :update }
              },
              delete: {
                '/admin/photos/:id' => { controller: 'Admin::PhotosController', action: :destroy }
              }
            }
          end

          let(:expected_paths) do
            {
              'admin_photos_path' => '/admin/photos',
              'admin_photos_url' => 'rcmdr://app/admin/photos',
              'admin_photo_path' => '/admin/photos/:id',
              'admin_photo_url' => 'rcmdr://app/admin/photos/:id',
              'edit_admin_photo_path' => '/admin/photos/:id/edit',
              'edit_admin_photo_url' => 'rcmdr://app/admin/photos/:id/edit',
              'new_admin_photo_path' => '/admin/photos/new',
              'new_admin_photo_url' => 'rcmdr://app/admin/photos/new'
            }
          end

          it_behaves_like 'the correct routes are drawn'
          it_behaves_like 'the correct paths are drawn'
        end

        context 'with nested namespaces' do
          subject(:routes) do
            described_class.new.draw do
              namespace :admin do
                namespace :super do
                  resources :users
                end
              end
            end
          end

          let(:expected_routes) do
            {
              root: {},
              get: {
                '/admin/super/users/:id/edit' => { controller: 'Admin::Super::UsersController', action: :edit },
                '/admin/super/users' => { controller: 'Admin::Super::UsersController', action: :index },
                '/admin/super/users/new' => { controller: 'Admin::Super::UsersController', action: :new },
                '/admin/super/users/:id' => { controller: 'Admin::Super::UsersController', action: :show }
              },
              post: {
                '/admin/super/users' => { controller: 'Admin::Super::UsersController', action: :create }
              },
              put: {
                '/admin/super/users/:id' => { controller: 'Admin::Super::UsersController', action: :update }
              },
              patch: {
                '/admin/super/users/:id' => { controller: 'Admin::Super::UsersController', action: :update }
              },
              delete: {
                '/admin/super/users/:id' => { controller: 'Admin::Super::UsersController', action: :destroy }
              }
            }
          end

          let(:expected_paths) do
            {
              'admin_super_users_path' => '/admin/super/users',
              'admin_super_users_url' => 'rcmdr://app/admin/super/users',
              'admin_super_user_path' => '/admin/super/users/:id',
              'admin_super_user_url' => 'rcmdr://app/admin/super/users/:id',
              'edit_admin_super_user_path' => '/admin/super/users/:id/edit',
              'edit_admin_super_user_url' => 'rcmdr://app/admin/super/users/:id/edit',
              'new_admin_super_user_path' => '/admin/super/users/new',
              'new_admin_super_user_url' => 'rcmdr://app/admin/super/users/new'
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
