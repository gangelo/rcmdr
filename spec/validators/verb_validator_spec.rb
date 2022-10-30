# frozen_string_literal: true

RSpec.describe Rcmdr::Validators::VerbValidator do
  subject(:verb_validator) do
    Class.new do
      include Rcmdr::Validators::VerbValidator
    end.new
  end

  let(:valid_verbs) { Rcmdr::Routing::Verbs::VERBS }

  describe 'constants' do
    describe 'VERBS' do
      it 'includes the VERBS' do
        expect(described_class::VERBS).to match_array valid_verbs
      end
    end
  end

  describe '#verb_valid?' do
    context 'when the verb is valid' do
      it 'returns true' do
        all_valid = valid_verbs.all? { |verb| verb_validator.verb_valid?(verb) }
        expect(all_valid).to be true
      end
    end

    context 'when the verb is invalid' do
      it 'returns false' do
        expect(verb_validator.verb_valid?(:invalid_verb)).to be false
      end
    end
  end

  describe '#validate_verb!' do
    subject(:validate_verb) do
      verb_validator.validate_verb! verb
    end

    context 'when the verb is valid' do
      let(:verb) { valid_verbs.first }

      it_behaves_like 'no error is raised'
    end

    context 'when the verb is invalid' do
      let(:verb) { :invalid_verb }
      let(:expected_error) do
        'Invalid verb. Expected "get, post, put, patch or delete", ' \
          'but received "invalid_verb" (Symbol).'
      end

      it_behaves_like 'an error is raised'
    end
  end
end
