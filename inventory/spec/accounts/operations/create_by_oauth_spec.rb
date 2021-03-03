# frozen_string_literal: true

RSpec.describe Accounts::Operations::CreateByOauth, type: :operation do
  subject { operation.call(provider: provider, payload: payload) }

  let(:payload) { OAUTH_PAYLOAD }
  let(:provider) { 'github' }

  let(:operation) do
    described_class.new(repo: account_repo)
  end

  let(:account_repo) do
    instance_double('AccountRepository', find_by_auth_identity: existed_account, create_with_identity: account)
  end

  let(:account) { Account.new(id: 2, name: 'Anton Other') }

  context 'when account exist in data base' do
    let(:existed_account) { Account.new(id: 1, name: 'Anton') }

    it { expect(subject).to be_success }
    it { expect(subject.value!).to eq(existed_account) }
  end

  context 'when account does not exist in data base' do
    let(:existed_account) { nil }

    context 'and data is valid' do
      it { expect(subject).to be_success }
      it { expect(subject.value!).to eq(account) }
    end
  end

  context 'with real dependencies' do
    let(:operation) { described_class.new }

    it { expect(subject).to be_success }
    it { expect(subject.value!).to be_a(Account) }

    # TODO: move to unit tests
    context 'and provider is invalid' do
      let(:provider) { 'invalid' }

      it { expect(subject).to be_failure }
      it { expect(subject.failure).to eq(:invalid_provider) }
    end

    context 'and payload is invalid' do
      let(:payload) { { 'extra' => { 'raw_info' => {} }, 'credentials' => {} } }

      it { expect(subject).to be_failure }
      it { expect(subject.failure).to eq(:invalid_payload) }
    end
  end
end
