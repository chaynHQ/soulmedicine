require 'rails_helper'

RSpec.describe ReactionsController, type: :routing do
  describe 'routing' do
    it 'routes to #update via PUT' do
      expect(put: '/pathways/foo/notes/bar/reaction').to route_to('reactions#update', course_id: 'foo', lesson_id: 'bar')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/pathways/foo/notes/bar/reaction').to route_to('reactions#update', course_id: 'foo', lesson_id: 'bar')
    end

    it 'routes to #destroy' do
      expect(delete: '/pathways/foo/notes/bar/reaction').to route_to('reactions#destroy', course_id: 'foo', lesson_id: 'bar')
    end

    it 'routes to #set_from_email' do
      expect(get: '/pathways/foo/notes/bar/reaction/set_from_email').to route_to('reactions#set_from_email', course_id: 'foo', lesson_id: 'bar')
    end
  end
end
