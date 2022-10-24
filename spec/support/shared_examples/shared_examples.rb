# frozen_string_literal: true

RSpec.shared_examples 'an error is raised' do
  it 'raises an error' do
    expect { subject }.to raise_error expected_error
  end
end
