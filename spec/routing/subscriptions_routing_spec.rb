require 'rails_helper'

RSpec.describe SubscriptionsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/subscriptions').to route_to('subscriptions#index')
    end

    it 'routes to #show' do
      expect(get: '/pathways/foo/subscription').to route_to('subscriptions#show', course_id: 'foo')
    end

    it 'routes to #update via PUT' do
      expect(put: '/pathways/foo/subscription').to route_to('subscriptions#update', course_id: 'foo')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/pathways/foo/subscription').to route_to('subscriptions#update', course_id: 'foo')
    end

    it 'routes to #destroy' do
      expect(delete: '/pathways/foo/subscription').to route_to('subscriptions#destroy', course_id: 'foo')
    end

    it 'routes to #pause' do
      expect(patch: '/pathways/foo/subscription/pause').to route_to('subscriptions#pause', course_id: 'foo')
    end

    it 'routes to #unpause' do
      expect(patch: '/pathways/foo/subscription/unpause').to route_to('subscriptions#unpause', course_id: 'foo')
    end
  end
end
