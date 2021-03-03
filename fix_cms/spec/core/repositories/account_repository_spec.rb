# frozen_string_literal: true

RSpec.describe AccountRepository, type: :repository do
  let(:repo) { described_class.new }

  describe '#find_by_auth_identity' do
    subject { repo.find_by_auth_identity(provider, auth_identity) }

    before do
      account = Fabricate(:account, name: 'Anton')
      Fabricate(:auth_identity, account_id: account.id, provider: 'github', login: 'davydovanton')
      Fabricate(:auth_identity, account_id: account.id, provider: 'google', login: 'email@test.com')
    end

    context 'when data can be mapped to account' do
      let(:provider) { 'github' }
      let(:auth_identity) do
        {
          login: 'davydovanton',
          email: 'email@test.com'
        }
      end

      it { expect(subject).to be_a(Account) }
      it { expect(subject.name).to eq('Anton') }
    end

    context 'when data can not be mapped to account' do
      let(:provider) { 'google' }
      let(:auth_identity) do
        {
          login: 'anton@test.com',
          email: 'email@test.com'
        }
      end

      it { expect(subject).to be(nil) }
    end
  end

  describe '#create_with_identity' do
    subject { repo.find_by_auth_identity(account, auth_identity) }

    let(:account) {}
    let(:auth_identity) {}

    xit { expect(subject).to be(:ok) }
  end
end
