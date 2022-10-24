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
        let(:options) { { module: 'Admin' } }
        let(:expected_mappings) do
          [
            'post /photos -> Admin::PhotosController#create',
            'delete /photos -> Admin::PhotosController#destroy',
            'get /photos/edit -> Admin::PhotosController#edit',
            'get /photos/new -> Admin::PhotosController#new',
            'get /photos -> Admin::PhotosController#show',
            'put /photos -> Admin::PhotosController#update',
            'patch /photos -> Admin::PhotosController#update'
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
        let(:expected_error) { Rcmdr::Errors::OptionTypeError }

        it_behaves_like 'an error is raised'
      end

      context 'when an unrecognized option is passed' do
        let(:resource) { :photos }
        let(:options) { { unrecognized_option: :unrecognized } }
        let(:expected_error) { Rcmdr::Errors::UnrecognizedOptionError }

        it_behaves_like 'an error is raised'
      end

      context 'with a blank? resource' do
        context 'with a nil? resource' do
          let(:resource) { nil }
          let(:options) { {} }
          let(:expected_error) { Rcmdr::Errors::InvalidResourceError }

          it_behaves_like 'an error is raised'
        end

        context 'with a blank? resource' do
          let(:resource) { '' }
          let(:options) { {} }
          let(:expected_error) { Rcmdr::Errors::InvalidResourceError }

          it_behaves_like 'an error is raised'
        end
      end

      context 'when arguments are valid' do
        let(:resource) { :photos }
        let(:options) { { module: 'Admin' } }
        let(:expected_mappings) do
          [
            'post /photos -> Admin::PhotosController#create',
            'get /photos -> Admin::PhotosController#index',
            'delete /photos/:id -> Admin::PhotosController#destroy',
            'get /photos/:id/edit -> Admin::PhotosController#edit',
            'get /photos/new -> Admin::PhotosController#new',
            'get /photos/:id -> Admin::PhotosController#show',
            'put /photos/:id -> Admin::PhotosController#update',
            'patch /photos/:id -> Admin::PhotosController#update'
          ]
        end

        it_behaves_like 'the mappings are correct'
      end
    end
  end
end
