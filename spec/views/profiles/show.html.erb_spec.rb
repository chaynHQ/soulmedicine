require 'rails_helper'

RSpec.describe 'profiles/show.html.erb', type: :view do
  it 'renders with vue component' do
    render

    expect(rendered).to match(/profile/)
  end
end
