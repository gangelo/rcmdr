# frozen_string_literal: true

RSpec.shared_context 'with routes' do
  let(:empty_verbs_hash) do
    Rcmdr::Routing::Verbs::VERBS.to_h { |verb| [verb, {}] }
  end
end

RSpec.configure do |config|
  config.include_context 'with routes'
end
