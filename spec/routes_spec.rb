# frozen_string_literal: true

RSpec.describe Rcmdr::Routes do
  describe 'instance methods' do
    it { is_expected.to respond_to :draw }

    describe '#draw' do
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
              get: { '/get': { to: 'controller#index', as: :list } },
              delete: { '/delete': { to: 'controller#delete', as: :delete } },
              patch: { '/put': { to: 'controller#patch', as: :patch } },
              post: { '/post': { to: 'controller#post', as: :post } },
              put: { '/put': { to: 'controller#put', as: :put } }
            }
          )
        end

        it 'draws the routes' do
          expect(routes.routes).to match expected_routes
        end
      end

      context 'when no &block is given' do
        it 'raises an error' do
          expect { described_class.new.draw }.to raise_error Rcmdr::Errors::NoBlockError
        end
      end

      describe '#resources' do
        subject(:routes) do
          described_class.new.draw do
            resources :photos
          end
        end

        let(:expected_routes) do
          {
            delete: {
              '/photos/:id': {
                to: 'photos#destroy'
              }
            },
            get: {
              '/photos/:id/edit': {
                to: 'photos#edit'
              },
              '/photos': {
                to: 'photos#index'
              },
              '/photos/new': {
                to: 'photos#new'
              },
              '/photos/:id': {
                to: 'photos#show'
              }
            },
            post: {
              '/photos': {
                to: 'photos#create'
              }
            },
            put: {
              '/photos/:id': {
                to: 'photos#update'
              }
            }
          }
        end

        it 'draws the routes' do
          expect(routes.routes).to match expected_routes
        end
      end
    end
  end
end
