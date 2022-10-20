# frozen_string_literal: true
RSpec.shared_examples 'the correct helper path is generated' do
  it "generates the expected helper path" do
    expect(helper_path_for).to eq expected_helper_path
  end
end

RSpec.shared_examples 'the correct helper url is generated' do
  it "generates the expected helper url" do
    expect(helper_url_for).to eq expected_helper_url
  end
end

RSpec.describe Rcmdr::Support::RouteHelpers do
  subject(:route_helpers) { described_class }

  let(:resource_or_as) { :photos }
  let(:resource_or_as_singular) { resource_or_as.to_s.singularize }

  describe '.helper_path_for' do
    subject(:helper_path_for) do
      route_helpers.helper_path_for(verb: verb, resource_or_as: resource_or_as, action: action)
    end

    context 'with verb :get' do
      let(:verb) { :get }

      context 'with action :index' do
        let(:action) { :index }
        let(:expected_helper_path) { "#{resource_or_as}_path" }

        it_behaves_like 'the correct helper path is generated'
      end

      context 'with action :new' do
        let(:action) { :new }
        let(:expected_helper_path) { "new_#{resource_or_as_singular}_path" }

        it_behaves_like 'the correct helper path is generated'
      end

      context 'with action :edit' do
        let(:action) { :edit }
        let(:expected_helper_path) { "edit_#{resource_or_as_singular}_path" }

        it_behaves_like 'the correct helper path is generated'
      end

      context 'with action :show' do
        let(:action) { :show }
        let(:expected_helper_path) { "show_#{resource_or_as_singular}_path" }

        it_behaves_like 'the correct helper path is generated'
      end
    end

    context 'with verb :post' do
      let(:verb) { :post }

      context 'with action :create' do
        let(:action) { :create }
        let(:expected_helper_path) { "#{resource_or_as}_path" }

        it_behaves_like 'the correct helper path is generated'
      end
    end

    context 'with verb :patch' do
      let(:verb) { :patch }

      context 'with action :update' do
        let(:action) { :update }
        let(:expected_helper_path) { "#{resource_or_as_singular}_path" }

        it_behaves_like 'the correct helper path is generated'
      end
    end

    context 'with verb :delete' do
      let(:verb) { :delete }

      context 'with action :update' do
        let(:action) { :destroy }
        let(:expected_helper_path) { "#{resource_or_as_singular}_path" }

        it_behaves_like 'the correct helper path is generated'
      end
    end
  end
end
