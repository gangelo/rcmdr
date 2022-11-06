# frozen_string_literal: true

RSpec.describe Rcmdr::Routing::Route do
  subject(:route) { described_class.new path, **options }

  describe '.initialize' do
    context 'when the path and options are valid' do
      context 'when using no :to option' do
        let(:path) { '/articles/index' }
        let(:options) { { verb: :get } }

        it_behaves_like 'no error is raised'
      end

      context 'when using the :to option' do
        let(:path) { '/articles' }
        let(:options) { { verb: :get, to: 'admin/articles#index' } }

        it_behaves_like 'no error is raised'
      end
    end

    context 'when an option is unrecognized' do
      let(:path) { '/photos/list' }
      let(:options) { { verb: :get, bad_option: true } }
      let(:expected_error) do
        'Invalid optional options. Expected "action, as, mod, namespace, to or verb", but received "bad_option".'
      end

      it_behaves_like 'an error is raised'
    end

    context 'when path is nil?' do
      let(:path) { nil }
      let(:options) { { verb: :delete } }
      let(:expected_error) { 'Unable to determine controller action from path "".' }

      it_behaves_like 'an error is raised'
    end

    context 'when path is an empty String' do
      let(:path) { '' }
      let(:options) { { verb: :patch } }
      let(:expected_error) { 'Unable to determine controller action from path "".' }

      it_behaves_like 'an error is raised'
    end

    context 'when path has a slug and option :to is not provided' do
      let(:path) { '/controller/:id/action' }
      let(:options) { { verb: :patch } }
      let(:expected_error) do
        "Unable to determine controller action from path \"#{path}\". " \
          'If your path includes a slug (e.g. :id), you must supply ' \
          'to: "<controller>#<action>" to resolve this ambiguity.'
      end

      it_behaves_like 'an error is raised'
    end

    context 'when path has no path and option :to is not provided' do
      let(:path) { '/controller' }
      let(:options) { { verb: :put } }
      let(:expected_error) do
        "Unable to determine controller action from path \"#{path}\". " \
          'If your path includes only 1 segment (e.g. /segment), you must add additional ' \
          'path controller_segments or supply to: "<controller>#<action>" to resolve this ambiguity.'
      end

      it_behaves_like 'an error is raised'
    end

    context 'when path has no path and option :to is not provided' do
      let(:path) { '/controller' }
      let(:options) { { verb: :get, to: 'controller' } }
      let(:expected_error) do
        "Unable to determine controller action from to: \"#{options[:to]}\". " \
          'You must add an action (e.g. to:[<namespace>/...]<controller>#<action>) ' \
          'to resolve this ambiguity.'
      end

      it_behaves_like 'an error is raised'
    end
  end

  describe '#print' do
    context 'without namespaces' do
      let(:path) { '/list_users' }
      let(:options) { { verb: :get, to: 'users#index' } }
      let(:expected_print) do
        'get /list_users -> UsersController#index'
      end

      it 'prints the route info' do
        expect(route.print).to eq expected_print
      end
    end

    context 'with namespaces' do
      let(:path) { '/admin_users' }
      let(:options) { { verb: :get, to: 'admin/users#index' } }
      let(:expected_print) do
        'get /admin_users -> Admin::UsersController#index'
      end

      it 'prints the route info' do
        expect(route.print).to eq expected_print
      end
    end
  end

  describe '#to_h' do
    let(:path) { '/admin_users' }
    let(:options) { { verb: :get, to: 'admin/users#index' } }
    let(:expected_hash) do
      {
        verb: :get,
        namespaces: ['Admin'],
        controller: 'UsersController',
        action: 'index',
        controller_class: 'Admin::UsersController',
        path: '/admin_users',
        helper_path: 'admin_users_path',
        helper_url: 'admin_users_url'
      }
    end

    it 'returns the route info as a Hash' do
      expect(route.to_h).to eq expected_hash
    end
  end

  describe '#helper_path' do
    context 'with a path and no to: option' do
      let(:path) { '/photos/index' }
      let(:options) { { verb: :get } }

      it 'returns the helper path name' do
        expect(route.helper_path).to eq 'photos_index_path'
      end
    end

    context 'with a path and to: option' do
      let(:path) { '/admin/users' }
      let(:options) { { verb: :get, to: 'admin/users#list' } }

      it 'returns the helper path name' do
        expect(route.helper_path).to eq 'admin_users_path'
      end
    end
  end

  describe '#url_for' do
    subject(:url_for) do
      described_class.new(path, **options)
        .url_for(host: :home_app, scheme: 'rcmdr', port: 77_007)
    end

    context 'with a path and no to: option' do
      let(:path) { '/photos/index' }
      let(:options) { { verb: :get } }

      it 'returns the helper path name' do
        expect(url_for).to eq 'rcmdr://home_app:77007/photos/index'
      end
    end

    context 'with a path and to: option' do
      let(:path) { '/photos/index' }
      let(:options) { { verb: :get, to: 'admin/photos#index' } }

      it 'returns the helper path name' do
        expect(url_for).to eq 'rcmdr://home_app:77007/photos/index'
      end
    end
  end

  describe 'verbs' do
    describe 'get' do
      let(:path) { '/articles/index' }
      let(:options) { { verb: :get } }

      it 'returns the expected route object' do
        expect(route.path).to eq path
        expect(route.verb).to eq :get
        expect(route.namespaces).to eq []
        expect(route.controller).to eq 'ArticlesController'
        expect(route.controller_class).to eq 'ArticlesController'
        expect(route.action).to eq 'index'
        expect(route.helper_path).to eq 'articles_index_path'
        expect(route.helper_url).to eq 'articles_index_url'
      end

      context 'with namespaces' do
        let(:path) { '/admin_users' }
        let(:options) { { verb: :get, to: 'admin/users#index' } }

        it 'returns the expected route object' do
          expect(route.path).to eq path
          expect(route.verb).to eq :get
          expect(route.namespaces).to eq %w[Admin]
          expect(route.controller).to eq 'UsersController'
          expect(route.controller_class).to eq 'Admin::UsersController'
          expect(route.action).to eq 'index'
          expect(route.helper_path).to eq 'admin_users_path'
          expect(route.helper_url).to eq 'admin_users_url'
        end
      end
    end
  end
end
