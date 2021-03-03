# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Auth::Views::ApplicationLayout, type: :view do
  let(:layout)   { described_class.new({ format: :html }, 'contents') }
  let(:rendered) { layout.render }
end
