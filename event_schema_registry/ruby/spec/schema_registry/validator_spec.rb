# frozen_string_literal: true

require 'schema_registry'

RSpec.describe SchemaRegistry::Validator do
  describe '#validate' do
    subject { validator.validate(data, event_name, version: version) }

    let(:validator) { described_class.new(loader: loader) }
    let(:loader) { SchemaRegistry::Loader.new(schemas_root_path: schemas_root_path) }
    let(:schemas_root_path) { File.expand_path('../support/schemas', __dir__) }

    let(:event_name) { 'domain.event' }
    let(:category) { 'general' }
    let(:version) { 1 }

    context 'when event schema is valid' do
      context 'when type schema is valid' do
        let(:data) do
          {
            event_id: SecureRandom.uuid,
            event_version: 1,
            event_name: 'Domain.Event',
            event_time: Time.now.to_s,
            producer: 'rspec',
            data_version: 1,
            data: {
              order_id: 1,
              account_uuid: SecureRandom.uuid,
            },
          }
        end

        it { expect(subject).to be_success }
      end

      context 'when event schema is invalid' do
        let(:data) { { data: { name: nil } } }

        it { expect(subject).to be_failure }

        it 'returns errors' do
          expect(subject.failure.count).to eq(7)
          expect(subject.failure.last).to include("The property '#/' did not contain a required property of 'producer' in schema")
        end
      end
    end
  end
end
