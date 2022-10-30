# frozen_string_literal: true

RSpec.describe Rcmdr::Validators::ControllerValidator do
  describe '.valid_controller?' do
    subject(:valid_controller) do
      described_class.valid_controller? controller
    end

    context 'when the controller name is valid' do
      let(:controller) { 'valid_controller' }

      it 'returns true' do
        expect(valid_controller).to be true
      end
    end

    context 'when the controller name is invalid' do
      let(:controller) { '$invalid_controller$' }

      it 'returns false' do
        expect(valid_controller).to be false
      end
    end
  end

  describe '.validate_controller!' do
    subject(:validate_controller) do
      described_class.validate_controller! controller
    end

    context 'when the controller name is valid' do
      let(:controller) { 'valid_controller' }

      it_behaves_like 'no error is raised'
    end

    context 'when the controller name is invalid' do
      let(:controller) { '$invalid_controller$' }
      let(:expected_error) do
        'Invalid controller name. Unable to determine controller from ' \
          '"$invalid_controller$". "$invalid_controller$" is not a supported controller name.'
      end

      it_behaves_like 'an error is raised'
    end
  end
end
