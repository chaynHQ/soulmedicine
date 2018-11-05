require 'rails_helper'

RSpec.describe PagesController, type: :routing do
  describe 'routing' do
    it 'routes to #landing' do
      expect(get: '/').to route_to('pages#landing')
    end
  end
end
