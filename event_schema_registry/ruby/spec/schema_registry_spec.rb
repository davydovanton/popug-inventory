# frozen_string_literal: true

require 'schema_registry'
require 'securerandom'

RSpec.describe SchemaRegistry do
  describe '#validate_event' do
    subject { described_class.validate_event(data, 'billing.refund', version: 1) }

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
          timestamp: Time.now.to_s
        },
      }
    end

    it { is_expected.to eq(SchemaRegistry::Result.new([])) }
  end
end
