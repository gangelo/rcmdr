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
        let(:expected_error) { Rcmdr::Errors::InvalidActionError }

        it 'raises an error' do
          expect { resource_class.verbs_for(action: :unrecognized_action) }.to raise_error expected_error
        end
      end
    end

    describe '.resource_valid?' do
      context 'when the resource is valid' do
        it 'returns true' do
          expect(described_class.resource_valid? :photos).to be true
        end
      end

      context 'when resource is invalid' do
        context 'when nil' do
          it 'returns false' do
            expect(described_class.resource_valid? nil).to be false
          end
        end

        context 'when an empty String' do
          it 'returns false' do
            expect(described_class.resource_valid? '').to be false
          end
        end
      end
    end

    describe '.validate_resource!' do
      subject(:resource_class) { described_class.validate_resource! resource }

      context 'when resource is blank?' do
        context 'when nil' do
          let(:resource) { nil }
          let(:expected_error) { Rcmdr::Errors::InvalidResourceError }

          it_behaves_like 'an error is raised'
        end

        context 'when an empty String' do
          let(:resource) { '' }
          let(:expected_error) { Rcmdr::Errors::InvalidResourceError }

          it_behaves_like 'an error is raised'
        end
      end
    end

    describe '.validate_options!' do
      subject(:resource_class) { described_class.validate_options! allowed_options:, options: }

      context 'when options are not allowed' do
        let(:allowed_options) { %i[a b c] }
        let(:options) { %i[a b c x y z] }
        let(:expected_error) { /"\[:x, :y, :z\]" were unrecognized/ }

        it_behaves_like 'an error is raised'
      end
    end
  end

  describe 'instance methods' do
    subject(:resource_class) { described_class.new resource, **options }

    let(:resource) { :photos }
    let(:options) { {} }

    describe '#print' do
      let(:options) { { verb: :get, action: :index } }

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
      let(:options) { { verb: :get, action: :index, mod: :admin } }
      let(:expected_hash) do
        {
          action: :index,
          controller: 'Admin::PhotosController',
          helper_path: 'photos_path',
          helper_url: 'photos_url',
          mod: :admin,
          path: '/photos',
          resource: :photos
        }
      end

      it 'returns the Hash representation of the object' do
        expect(resource_class.to_h).to eq expected_hash
      end
    end

    describe '#controller' do
      context 'with no module' do
        let(:options) { { verb: :get, action: :index } }

        it 'returns the controller' do
          expect(resource_class.controller).to eq 'PhotosController'
        end
      end

      context 'with a module' do
        let(:options) { { verb: :get, action: :index, mod: :admin } }

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
        expected_url = 'rcmdr://host:3000/path'
        expect(resource_class.url_for(host: 'host', path: '/path', scheme: 'rcmdr', port: 3000)).to eq expected_url
      end
    end
  end
end
