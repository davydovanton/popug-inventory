# frozen_string_literal: true

RSpec.describe Auth::Controllers::OauthSession::Create, type: :action do
  subject { action.call(params) }

  let(:action) { described_class.new(operation: operation) }
  let(:params) { { provider: :github, 'omniauth.auth' => OAUTH_PAYLOAD } }

  context 'when operation returns success result' do
    let(:operation) { ->(*) { Success(Account.new(id: 123)) } }

    it { expect(subject).to redirect_to '/' }

    it 'stores finding account in session' do
      subject
      expect(action.session[:account]).to eq(Account.new(id: 123))
    end

    context 'and origin option is set' do
      let(:params) { { provider: :github, 'omniauth.origin' => '/test' } }

      it { expect(subject).to redirect_to '/test' }
    end
  end

  context 'when operation returns failure result' do
    let(:operation) { ->(*) { Failure(:error) } }

    it { expect(subject).to redirect_to '/auth/login' }

    it 'stores nothing in session' do
      subject
      expect(action.session[:account]).to eq(nil)
    end
  end

  context 'with real dependencies' do
    subject { action.call(params) }

    let(:action) { described_class.new }

    it { expect(subject).to redirect_to '/' }
  end
end
