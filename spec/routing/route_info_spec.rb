# frozen_string_literal: true

RSpec.describe Rcmdr::Routing::RouteInfo do
  subject(:route_info) do
    described_class.new(path, verb:, **options)
  end

  let(:path) { nil }
  let(:verb) { nil }
  let(:options) { {} }

  describe '.initialize' do
    context 'with valid arguments' do
      let(:path) { '/cars/index' }
      let(:verb) { :get }
      let(:options) { {} }

      it_behaves_like 'no error is raised'
    end

    context 'with invalid arguments' do
      context 'when path is not a String' do
        let(:path) { nil }
        let(:verb) { :get }
        let(:options) { {} }

        let(:expected_error) do
          'Path is invalid. Expected a non-blank? String, but recieved "" (NilClass).'
        end

        it_behaves_like 'an error is raised'
      end

      context 'when path is an empty String' do
        let(:path) { '' }
        let(:verb) { :get }
        let(:options) { {} }

        let(:expected_error) do
          'Path is invalid. Expected a non-blank? String, but recieved "" (String).'
        end

        it_behaves_like 'an error is raised'
      end

      context 'when verb: is not a valid verb' do
        let(:path) { '/article/list' }
        let(:verb) { :invalid_verb }
        let(:options) { {} }

        let(:expected_error) do
          'Invalid verb. Expected "get, post, put, patch or delete", ' \
            'but received "invalid_verb" (Symbol).'
        end

        it_behaves_like 'an error is raised'
      end

      context 'when options: has an invalid option' do
        let(:path) { '/article/list' }
        let(:verb) { :put }
        let(:options) { { invalid_option: :invalid_option_value } }

        let(:expected_error) do
          'Invalid optional options. Expected "as, namespace or to", but received "invalid_option".'
        end

        it_behaves_like 'an error is raised'
      end
    end
  end

  describe '#prefix' do
    subject(:prefix) do
      described_class.new(path, verb:, **options).prefix
    end

    context 'root' do
      context 'when option :as is not used' do
        let(:path) { 'home#index' }
        let(:verb) { :root }
        let(:options) { {} }

        it 'returns the correct prefix' do
          expect(prefix).to eq 'root'
        end
      end

      context 'when option :as is used' do
        let(:path) { 'admin/users#index' }
        let(:verb) { :root }
        let(:options) { { as: 'home' } }

        it 'returns the correct prefix' do
          expect(prefix).to eq 'home'
        end
      end

      context 'when option :namespace is used' do
        let(:path) { 'home#index' }
        let(:verb) { :root }
        let(:options) { { namespace: [:admin] } }

        it 'returns the correct prefix' do
          expect(prefix).to eq 'admin_root'
        end
      end
    end

    context 'when not root' do
      context 'when option :as is not used' do
        let(:path) { '/photos/index' }
        let(:verb) { :put }
        let(:options) { {} }

        it 'returns the correct prefix' do
          expect(prefix).to eq 'photos_index'
        end
      end

      context 'when option :as is used' do
        let(:path) { '/photos/index' }
        let(:verb) { :put }
        let(:options) { { as: 'photos_home' } }

        it 'returns the correct prefix' do
          expect(prefix).to eq 'photos_home'
        end
      end
    end
  end

  describe '#controller_action' do
    subject(:controller_action) do
      described_class.new(path, verb:, **options).controller_action
    end

    context 'when root without inline namespaces' do
      context 'when option :to is not used' do
        let(:path) { 'users#index' }
        let(:verb) { :root }
        let(:options) { {} }

        it 'returns whatever was used for the path' do
          expect(controller_action).to eq path
        end
      end

      context 'when option :to is used' do
        let(:path) { 'users#index' }
        let(:verb) { :root }
        let(:options) { { to: 'users/profiles#index' } }

        it 'returns whatever was used for the path (option :to is ignored)' do
          expect(controller_action).to eq path
        end
      end
    end

    context 'when root with inline namespaces' do
      context 'when option :to is not used' do
        let(:path) { 'admin/users#index' }
        let(:verb) { :root }
        let(:options) { {} }

        it 'returns whatever was used for the path' do
          expect(controller_action).to eq path
        end
      end

      context 'when option :to is used' do
        let(:path) { 'admin/users#index' }
        let(:verb) { :root }
        let(:options) { { to: 'users/profiles#index' } }

        it 'returns whatever was used for the path (option :to is ignored)' do
          expect(controller_action).to eq path
        end
      end
    end

    context 'when root with option :namespace' do
      context 'when option :to is not used' do
        let(:path) { 'home#index' }
        let(:verb) { :root }
        let(:options) { { namespace: [:admin] } }

        it 'returns the namespace/path#action' do
          expect(controller_action).to eq 'admin/home#index'
        end
      end

      context 'when option :to is used' do
        let(:path) { 'home#index' }
        let(:verb) { :root }
        let(:options) { { to: 'ignored/home#index',  namespace: [:admin] } }

        it 'returns namespace/path#action (option :to is ignored)' do
          expect(controller_action).to eq 'admin/home#index'
        end
      end
    end

    context 'when not root without inline namespaces' do
      context 'when option :to is not used' do
        let(:path) { '/admin/users' }
        let(:verb) { :get }
        let(:options) { {} }

        it 'returns <controller>#<action>' do
          expect(controller_action).to eq 'admin#users'
        end
      end

      context 'when option :to is used' do
        let(:path) { '/admin/users' }
        let(:verb) { :get }
        let(:options) { { to: 'admin/users#index' } }

        it 'returns path <controller>#<action> (option :to is ignored)' do
          expect(controller_action).to eq 'admin/users#index'
        end
      end
    end

    context 'when not root with inline namespaces' do
      context 'when option :to is not used' do
        let(:path) { '/admin/articles/list' }
        let(:verb) { :get }
        let(:options) { {} }

        it 'returns <namespace>/[<namespace>/..]<controller>#<action>' do
          expect(controller_action).to eq 'admin/articles#list'
        end
      end

      context 'when option :to is used' do
        let(:path) { '/super_users/users' }
        let(:verb) { :get }
        let(:options) { { to: 'admin/supers/users#list' } }

        it 'returns path <namespace>/[<namespace>/..]<controller>#<action> (option :to is used)' do
          expect(controller_action).to eq 'admin/supers/users#list'
        end
      end
    end

    context 'when not root with option :namespace' do
      context 'when option :to is not used' do
        let(:path) { '/home/index' }
        let(:verb) { :get }
        let(:options) { { namespace: [:admin] } }

        it 'returns <namespace>/[<namespace>/..]<controller>#<action>' do
          expect(controller_action).to eq 'admin/home#index'
        end
      end

      context 'when option :to is used' do
        let(:path) { '/home/index' }
        let(:verb) { :get }
        let(:options) { { to: 'admin/supers/users#list' } }

        it 'returns path <namespace>/[<namespace>/..]<controller>#<action> (option :to is used)' do
          expect(controller_action).to eq 'admin/supers/users#list'
        end
      end
    end
  end
end
