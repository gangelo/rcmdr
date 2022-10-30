# frozen_string_literal: true

RSpec.describe Rcmdr::Validators::OptionValidator do
  subject(:option_validator) do
    Class.new do
      include Rcmdr::Validators::OptionValidator
    end.new
  end

  describe '#option_valid?' do
    context 'when the option is valid' do
      it 'returns true' do
        expect(subject.option_valid?(:option, allowed_options: :option)).to be true
      end
    end

    context 'when the option is not valid' do
      it 'returns false' do
        expect(subject.option_valid?(:bad_option, allowed_options: :option)).to be false
      end
    end
  end

  describe '#validate_required_options!' do
    context 'when there there are no options missing' do
      let(:options) { %i[one two three four] }
      let(:required_options) { %i[one two three four] }

      it 'raises an error' do
        expect do
          subject.validate_required_options!(options:, required_options:)
        end.not_to raise_error
      end
    end

    context 'when there there are options missing' do
      let(:options) { %i[one three] }
      let(:required_options) { %i[one two three four] }
      let(:expected_error) do
        'Missing required options. Expected "one, two, three or four", but "two and four" are missing.'
      end

      it 'raises an error' do
        expect do
          subject.validate_required_options!(options:, required_options:)
        end.to raise_error expected_error
      end
    end
  end

  describe '#validate_options!' do
    context 'when there there are no unrecognized options' do
      let(:options) { %i[one two three four] }
      let(:allowed_options) { %i[one two three four] }

      it 'raises an error' do
        expect do
          subject.validate_options!(options:, allowed_options:)
        end.not_to raise_error
      end
    end

    context 'when there there are one or more unrecognized options' do
      let(:options) { %i[zero five] }
      let(:allowed_options) { %i[one two three four] }
      let(:expected_error) do
        'Invalid optional options. Expected "one, two, three or four", but received "zero and five".'
      end

      it 'raises an error' do
        expect do
          subject.validate_options!(options:, allowed_options:)
        end.to raise_error expected_error
      end
    end
  end
end
