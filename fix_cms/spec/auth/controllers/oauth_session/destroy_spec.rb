# frozen_string_literal: true

RSpec.describe Auth::Controllers::OauthSession::Destroy, type: :action do
  subject { action.call(params) }

  let(:action) { described_class.new }
  let(:params) { { 'rack.session' => session } }

  let(:session) { { account: account } }
  let(:account) { Account.new(id: 1) }

  it { expect(subject).to redirect_to '/auth/login' }

  it 'delete current account from the session' do
    subject
    expect(action.session[:account]).to eq(nil)
  end
end
