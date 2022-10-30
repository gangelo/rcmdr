# frozen_string_literal: true

RSpec.shared_examples 'no error is raised' do
  it 'raises no error' do
    expect { subject }.not_to raise_error
  end
end

RSpec.shared_examples 'an error is raised' do
  it 'raises an error' do
    expect { subject }.to raise_error expected_error
  end
end

RSpec.shared_examples 'the correct routes are drawn' do
  it 'generates the routes' do
    expect(subject.routes).to eq expected_routes
  end
end

RSpec.shared_examples 'the correct paths are drawn' do
  it 'generates the paths' do
    expect(subject.paths).to eq expected_paths
  end
end
