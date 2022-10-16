# frozen_string_literal: true

RSpec.describe Rcmdr::Command do
  subject(:command) do
    Class.new do
      class << self
        def name
          'Test'
        end
      end

      include Rcmdr::Command
    end
  end

  describe 'included' do
    context 'when the class has no .name (<class>.name.blank?)' do
      subject(:command) { Class.new { include Rcmdr::Command } }

      it 'returns the command namespace' do
        expect { command }.to raise_error Rcmdr::NoClassNameError
      end
    end
  end

  describe 'class methods' do
    describe '.command_namespace' do
      context 'when no command_namespace is explicitly coded' do
        it 'returns the command namespace' do
          expect(command.command_namespace).to eq :test
        end
      end

      context 'when the command_namespace is explicitly coded' do
        subject(:command) do
          Class.new do
            class << self
              def name
                'Test'
              end
            end

            include Rcmdr::Command

            command_namespace :explicit_namespace
          end
        end

        it 'returns the command namespace' do
          expect(command.command_namespace).to eq :explicit_namespace
        end
      end
    end
  end
end
