# frozen_string_literal: true

RSpec.shared_examples 'the correct helper path is generated' do
  it 'generates the expected helper path' do
    expect(resource_helper_path_for).to eq expected_helper_path
  end
end

RSpec.shared_examples 'the correct helper url is generated' do
  it 'generates the expected helper url' do
    expect(resource_helper_url_for).to eq expected_helper_url
  end
end

RSpec.shared_examples 'the correct url is generated' do
  it 'generates the expected url' do
    expect(url_for).to eq expected_url
  end
end

RSpec.describe Rcmdr::Routing::ResourceHelpers do
  subject(:resource_helpers) { described_class }

  let(:resource) { :photos }
  let(:resource_singular) { resource.to_s.singularize }

  describe '.resource_helper_url_for' do
    subject(:resource_helper_url_for) do
      resource_helpers.resource_helper_url_for(verb:, resource:, action:)
    end

    context 'with verb :get' do
      let(:verb) { :get }

      context 'with action :index' do
        let(:action) { :index }
        let(:expected_helper_url) { "#{resource}_url" }

        it_behaves_like 'the correct helper url is generated'
      end
    end
  end

  describe '.resource_helper_path_for' do
    subject(:resource_helper_path_for) do
      resource_helpers.resource_helper_path_for(verb:, resource:, action:)
    end

    context 'with verb :get' do
      let(:verb) { :get }

      context 'with action :index' do
        let(:action) { :index }
        let(:expected_helper_path) { "#{resource}_path" }

        it_behaves_like 'the correct helper path is generated'
      end

      context 'with action :new' do
        let(:action) { :new }
        let(:expected_helper_path) { "new_#{resource_singular}_path" }

        it_behaves_like 'the correct helper path is generated'
      end

      context 'with action :edit' do
        let(:action) { :edit }
        let(:expected_helper_path) { "edit_#{resource_singular}_path" }

        it_behaves_like 'the correct helper path is generated'
      end

      context 'with action :show' do
        let(:action) { :show }
        let(:expected_helper_path) { "show_#{resource_singular}_path" }

        it_behaves_like 'the correct helper path is generated'
      end
    end

    context 'with verb :post' do
      let(:verb) { :post }

      context 'with action :create' do
        let(:action) { :create }
        let(:expected_helper_path) { "#{resource}_path" }

        it_behaves_like 'the correct helper path is generated'
      end
    end

    context 'with verb :patch' do
      let(:verb) { :patch }

      context 'with action :update' do
        let(:action) { :update }
        let(:expected_helper_path) { "#{resource_singular}_path" }

        it_behaves_like 'the correct helper path is generated'
      end
    end

    context 'with verb :delete' do
      let(:verb) { :delete }

      context 'with action :update' do
        let(:action) { :destroy }
        let(:expected_helper_path) { "#{resource_singular}_path" }

        it_behaves_like 'the correct helper path is generated'
      end
    end

    context 'with an unrecognized verb' do
      let(:verb) { :very_bad_verb }
      let(:action) { :index }
      let(:expected_helper_path) { 'will never reach me' }

      it 'raises an error' do
        expect { resource_helper_path_for }.to raise_error Rcmdr::Errors::InvalidVerbError
      end
    end

    context 'with an unrecognized action' do
      let(:verb) { :get }
      let(:action) { :very_bad_action }
      let(:expected_helper_path) { 'will never reach me' }

      it 'raises an error' do
        expect { resource_helper_path_for }.to raise_error Rcmdr::Errors::InvalidActionError
      end
    end
  end

  describe '.url_for' do
    subject(:url_for) do
      resource_helpers.url_for(host:, path:, scheme:, port:)
    end

    let(:scheme) { 'rcmdr' }
    let(:host) { 'app' }
    let(:path) { 'phones' }
    let(:port) { 3000 }
    let(:expected_url) do
      URI.join("#{scheme}://#{host}:#{port}/", path).to_s
    end

    it_behaves_like 'the correct url is generated'
  end
end
