# frozen_string_literal: true

RSpec.describe Rcmdr::Validators::RootRouteValidator do
  describe '#valid_root_controller_action?' do
    context 'when the root controller action is valid' do
      it 'returns true' do
        expect(described_class.valid_root_controller_action?('controller#action'))
          .to eq true
        expect(described_class.valid_root_controller_action?('namespace/controller#action'))
          .to eq true
      end
    end

    context 'when the root controller action is invalid' do
      it 'returns false' do
        expect(described_class.valid_root_controller_action?(nil))
          .to eq false
        expect(described_class.valid_root_controller_action?(''))
          .to eq false
        expect(described_class.valid_root_controller_action?('/controller#action'))
          .to eq false
        expect(described_class.valid_root_controller_action?('controller#action#badaction'))
          .to eq false
        expect(described_class.valid_root_controller_action?('BADcontroller#action'))
          .to eq false
      end
    end
  end

  describe '#validate_root_controller_action!' do
    subject(:option_validator) do
      Class.new do
        include Rcmdr::Validators::RootRouteValidator

        def initialize(controller_action:)
          validate_root_controller_action! controller_action
        end
      end.new(controller_action:)
    end

    context 'when the root controller action is valid' do
      let(:controller_action) { 'controller#action' }

      it_behaves_like 'no error is raised'
    end

    context 'when the root controller action is invalid' do
      let(:controller_action) { '/controller#action' }
      let(:expected_error) do
        'Invalid root controller and action. ' \
          'Unable to determine root controller and action from "/controller#action". ' \
          '"/controller#action" is not a supported root controller ' \
          'and action format and/or combination.'
      end

      it_behaves_like 'an error is raised'
    end
  end
end
