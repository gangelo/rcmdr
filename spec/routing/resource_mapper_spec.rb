# frozen_string_literal: true

RSpec.shared_examples 'the mappings are correct' do
  it 'returns the correct resource mappings' do
    actual_mappings = subject.map(&:print)
    expect(actual_mappings).to match_array expected_mappings
  end
end

RSpec.describe Rcmdr::Routing::ResourceMapper do
  describe 'class methods' do
    describe '.map_resource' do
      subject(:resource_mapper) { described_class.map_resource resource, **options }

      let(:resource) { :photos }
      let(:options) { {} }

      it 'returns an Array of Resource objects' do
        all = resource_mapper.all? do |resource_map|
          resource_map.instance_of?(Rcmdr::Routing::Resource)
        end
        expect(all).to be true
      end

      context 'when arguments are valid' do
        let(:resource) { :photos }
        let(:options) { { namespace: ['admin'] } }
        let(:expected_mappings) do
          [
            'post /admin/photos -> Admin::PhotosController#create',
            'delete /admin/photos -> Admin::PhotosController#destroy',
            'get /admin/photos/edit -> Admin::PhotosController#edit',
            'get /admin/photos/new -> Admin::PhotosController#new',
            'get /admin/photos -> Admin::PhotosController#show',
            'put /admin/photos -> Admin::PhotosController#update',
            'patch /admin/photos -> Admin::PhotosController#update'
          ]
        end

        it_behaves_like 'the mappings are correct'
      end
    end

    describe '.map_resources' do
      subject(:resources_mapper) { described_class.map_resources resource, **options }

      let(:resource) { :photos }
      let(:options) { {} }

      it 'returns an Array of Resources objects' do
        all = resources_mapper.all? do |resources_map|
          resources_map.instance_of?(Rcmdr::Routing::Resources)
        end
        expect(all).to be true
      end

      context 'when :only is the wrong type' do
        let(:resource) { :photos }
        let(:options) { { only: :wrong_type } }
        let(:expected_error) do
          /options\[:only\] is not an Array/
        end

        it_behaves_like 'an error is raised'
      end

      context 'when an unrecognized option is passed' do
        let(:resource) { :photos }
        let(:options) { { unrecognized_option: :unrecognized } }

        it_behaves_like 'no error is raised'
      end

      context 'with a blank? resource' do
        context 'with a nil? resource' do
          let(:resource) { nil }
          let(:options) { {} }
          let(:expected_error) do
            'Resource "" (NilClass) is not present?'
          end

          it_behaves_like 'an error is raised'
        end

        context 'with a blank? resource' do
          let(:resource) { '' }
          let(:options) { {} }
          let(:expected_error) do
            'Resource "" (String) is not present?'
          end

          it_behaves_like 'an error is raised'
        end
      end

      context 'when arguments are valid' do
        let(:resource) { :photos }
        let(:options) { { namespace: ['admin'] } }
        let(:expected_mappings) do
          [
            'post /admin/photos -> Admin::PhotosController#create',
            'get /admin/photos -> Admin::PhotosController#index',
            'delete /admin/photos/:id -> Admin::PhotosController#destroy',
            'get /admin/photos/:id/edit -> Admin::PhotosController#edit',
            'get /admin/photos/new -> Admin::PhotosController#new',
            'get /admin/photos/:id -> Admin::PhotosController#show',
            'put /admin/photos/:id -> Admin::PhotosController#update',
            'patch /admin/photos/:id -> Admin::PhotosController#update'
          ]
        end

        it_behaves_like 'the mappings are correct'
      end
    end
  end
end
