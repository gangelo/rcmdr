# frozen_string_literal: true

RSpec.describe Rcmdr::Routing::ResourceRouteInfo do
  subject(:resource_route_info) do
    described_class.new(resource, verb:, action:, **options)
  end

  let(:resource) { nil }
  let(:verb) { nil }
  let(:action) { nil }
  let(:options) { nil }

  describe '.initialize' do
    context 'with valid arguments' do
      let(:resource) { :articles }
      let(:verb) { :get }
      let(:action) { :index }
      let(:options) { {} }

      it_behaves_like 'no error is raised'
    end

    context 'with invalid arguments' do
      subject(:resource_route_info) do
        described_class.new(resource, verb:, action:, **options)
      end

      let(:resource) { :articles }
      let(:verb) { :get }
      let(:action) { :index }
      let(:options) { {} }

      context 'when resource is not a String or Symbol' do
        let(:resource) { nil }

        let(:expected_error) do
          'Resource is invalid. Expected String or Symbol, but recieved "" (NilClass).'
        end

        it_behaves_like 'an error is raised'
      end

      context 'when verb: is nil' do
        let(:verb) { nil }

        let(:expected_error) do
          'Invalid verb. Expected "get, post, put, patch or delete", but received "" (NilClass).'
        end

        it_behaves_like 'an error is raised'
      end

      context 'when action: is nil' do
        let(:action) { nil }

        let(:expected_error) do
          'Invalid verb. Expected "create, destroy, edit, index, new, show or update", ' \
            'but received "" (NilClass).'
        end

        it_behaves_like 'an error is raised'
      end

      context 'when verb: is not a valid verb' do
        let(:verb) { :invalid_verb }

        let(:expected_error) do
          'Invalid verb. Expected "get, post, put, patch or delete", but received "invalid_verb" (Symbol).'
        end

        it_behaves_like 'an error is raised'
      end

      context 'when action: is not a valid action' do
        let(:action) { :invalid_action }

        let(:expected_error) do
          'Invalid verb. Expected "create, destroy, edit, index, new, show or update", ' \
            'but received "invalid_action" (Symbol).'
        end

        it_behaves_like 'an error is raised'
      end
    end

    context 'with valid arguments' do
      let(:resource) { :articles }
      let(:verb) { :get }
      let(:action) { :index }
      let(:options) { {} }

      describe '#resource_singular' do
        let(:resource) { :photos }

        it 'returns the resource name singularized' do
          expect(resource_route_info.resource_singular).to eq 'photo'
        end
      end

      describe '#resource_plural' do
        let(:resource) { :photo }

        it 'returns the resource name pluralized' do
          expect(resource_route_info.resource_plural).to eq 'photos'
        end
      end

      describe '#prefix' do
        let(:resource) { :article }

        context 'when action is :index' do
          let(:action) { :index }

          it 'returns "<pluralized resource name>"' do
            expect(resource_route_info.prefix).to eq 'articles'
          end
        end

        context 'when action is :create' do
          let(:action) { :create }

          it 'returns "<pluralized resource name>"' do
            expect(resource_route_info.prefix).to eq 'articles'
          end
        end

        context 'when action is :new' do
          let(:action) { :new }

          it 'returns "new_<singularized resource name>"' do
            expect(resource_route_info.prefix).to eq 'new_article'
          end
        end

        context 'when action is :edit' do
          let(:action) { :edit }

          it 'returns "edit_<singularized resource name>"' do
            expect(resource_route_info.prefix).to eq 'edit_article'
          end
        end

        context 'when action is :show, :update or :destroy' do
          let(:actions) { %i[show update destroy] }

          it 'returns "<singularized resource name>"' do
            expect(
              actions.all? do |action|
                described_class.new(resource, verb:, action:, **options).prefix == 'article'
              end
            ).to eq true
          end
        end
      end

      describe '#uri_pattern' do
        let(:resource) { :article }

        context 'when action is :index' do
          let(:action) { :index }

          it 'returns "/<pluralized uri pattern>"' do
            expect(resource_route_info.uri_pattern).to eq  "/articles"
          end
        end

        context 'when action is :create' do
          let(:action) { :create }

          it 'returns "/<pluralized uri pattern>"' do
            expect(resource_route_info.uri_pattern).to eq '/articles'
          end
        end

        context 'when action is :new' do
          let(:action) { :new }

          it 'returns "/<pluralized resource name>/new"' do
            expect(resource_route_info.uri_pattern).to eq '/articles/new'
          end
        end

        context 'when action is :edit' do
          let(:action) { :edit }

          it 'returns "/<pluralized resource name>/:id/edit"' do
            expect(resource_route_info.uri_pattern).to eq '/articles/:id/edit'
          end
        end

        context 'when action is :show, :update or :destroy' do
          let(:actions) { %i[show update destroy] }

          it 'returns "/<pluralized resource name>/:id"' do
            expect(
              actions.all? do |action|
                described_class.new(resource, verb:, action:, **options).uri_pattern == '/articles/:id'
              end
            ).to eq true
          end
        end
      end

      describe '#controller_action' do
        let(:actions) { %i[show update destroy] }

        it 'returns "<controller>#<action>"' do
          expect(
            actions.all? do |action|
              described_class.new(resource, verb:, action:, **options).controller_action == "articles##{action}"
            end
          ).to eq true
        end
      end
    end
  end
end
