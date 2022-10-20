# frozen_string_literal: true

RSpec.describe Rcmdr::Application do
  describe 'instance methods' do
    it { is_expected.to respond_to :routes }
  end
end
