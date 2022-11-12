# frozen_string_literal: true

RSpec.describe Rcmdr::Routing::Resource do
  subject(:resource_class) { described_class.new resource, **options }

  describe 'class methods' do
    describe '.verbs_for' do
      subject(:resource_class) { described_class }

      it 'returns the correct verbs for the action' do
        expect(resource_class.verbs_for(action: :create)).to match_array %i[post]
        expect(resource_class.verbs_for(action: :destroy)).to match_array %i[delete]
        expect(resource_class.verbs_for(action: :update)).to match_array %i[put patch]
        expect(resource_class.verbs_for(action: :edit)).to match_array %i[get]
        expect(resource_class.verbs_for(action: :new)).to match_array %i[get]
        expect(resource_class.verbs_for(action: :show)).to match_array %i[get]
      end

      context 'when an invalid action is passed' do
        let(:expected_error) do
          'Invalid action: "unrecognized_action"'
        end

        it 'raises an error' do
          expect { resource_class.verbs_for(action: :unrecognized_action) }.to raise_error expected_error
        end
      end
    end
  end

  describe 'instance methods' do
    subject(:resource_class) { described_class.new resource, **options }

    let(:resource) { :photos }
    let(:options) { {} }

    describe '#print' do
      it 'prints the mapping' do
        expect(described_class.new(resource, verb: :post, action: :create).print).to \
          eq 'post /photos -> PhotosController#create'
        expect(described_class.new(resource, verb: :get, action: :index).print).to \
          eq 'get /photos -> PhotosController#index'
        expect(described_class.new(resource, verb: :delete, action: :destroy).print).to \
          eq 'delete /photos -> PhotosController#destroy'
        expect(described_class.new(resource, verb: :get, action: :edit).print).to \
          eq 'get /photos/edit -> PhotosController#edit'
        expect(described_class.new(resource, verb: :get, action: :new).print).to \
          eq 'get /photos/new -> PhotosController#new'
        expect(described_class.new(resource, verb: :get, action: :show).print).to \
          eq 'get /photos -> PhotosController#show'
        expect(described_class.new(resource, verb: :put, action: :update).print).to \
          eq 'put /photos -> PhotosController#update'
        expect(described_class.new(resource, verb: :patch, action: :update).print).to \
          eq 'patch /photos -> PhotosController#update'
      end
    end

    describe '#to_h' do
      let(:options) { { verb: :get, action: :index, namespace: [:admin] } }
      let(:expected_hash) do
        {
          action: :index,
          controller: 'Admin::PhotosController',
          helper_path: 'admin_photos_path',
          helper_url: 'admin_photos_url',
          path: '/admin/photos',
          resource: :photos
        }
      end

      it 'returns the Hash representation of the object' do
        expect(resource_class.to_h).to eq expected_hash
      end
    end

    describe '#controller' do
      context 'with no namespace' do
        let(:options) { { verb: :get, action: :index } }

        it 'returns the controller' do
          expect(resource_class.controller).to eq 'PhotosController'
        end
      end

      context 'with a namespace' do
        let(:options) { { verb: :get, action: :index, namespace: [:admin] } }

        it 'returns the controller' do
          expect(resource_class.controller).to eq 'Admin::PhotosController'
        end
      end
    end

    describe '#helper_path' do
      it 'returns the controller' do
        expect(described_class.new(resource, verb: :post, action: :create).helper_path).to \
          eq 'photos_path'
        expect(described_class.new(resource, verb: :get, action: :index).helper_path).to \
          eq 'photos_path'
        expect(described_class.new(resource, verb: :delete, action: :destroy).helper_path).to \
          eq 'photo_path'
        expect(described_class.new(resource, verb: :get, action: :edit).helper_path).to \
          eq 'edit_photo_path'
        expect(described_class.new(resource, verb: :get, action: :new).helper_path).to \
          eq 'new_photo_path'
        expect(described_class.new(resource, verb: :get, action: :show).helper_path).to \
          eq 'photo_path'
        expect(described_class.new(resource, verb: :put, action: :update).helper_path).to \
          eq 'photo_path'
        expect(described_class.new(resource, verb: :patch, action: :update).helper_path).to \
          eq 'photo_path'
      end
    end

    describe '#helper_url' do
      it 'returns the controller' do
        expect(described_class.new(resource, verb: :post, action: :create).helper_url).to \
          eq 'photos_url'
        expect(described_class.new(resource, verb: :get, action: :index).helper_url).to \
          eq 'photos_url'
        expect(described_class.new(resource, verb: :delete, action: :destroy).helper_url).to \
          eq 'photo_url'
        expect(described_class.new(resource, verb: :get, action: :edit).helper_url).to \
          eq 'edit_photo_url'
        expect(described_class.new(resource, verb: :get, action: :new).helper_url).to \
          eq 'new_photo_url'
        expect(described_class.new(resource, verb: :get, action: :show).helper_url).to \
          eq 'photo_url'
        expect(described_class.new(resource, verb: :put, action: :update).helper_url).to \
          eq 'photo_url'
        expect(described_class.new(resource, verb: :patch, action: :update).helper_url).to \
          eq 'photo_url'
      end
    end

    describe '#url_for' do
      subject(:resource_class) { described_class.new(resource, verb: :put, action: :update) }

      it 'does something' do
        expected_url = 'rcmdr://host:3000/photos'
        expect(resource_class.url_for(host: 'host', scheme: 'rcmdr', port: 3000)).to eq expected_url
      end
    end
  end
end
