# frozen_string_literal: true

RSpec.describe Auth::Views::Signin::Index, type: :view do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/auth/templates/signin/index.html.slim') }
  let(:view)      { described_class.new(template, **exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    expect(view.format).to eq exposures.fetch(:format)
  end
end
