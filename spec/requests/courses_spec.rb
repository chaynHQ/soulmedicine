require 'rails_helper'

RSpec.describe 'Courses', type: :request do
  include_context 'courses_service double'

  let(:course) { load_course('course-1.json') }

  before do
    allow(courses_service).to receive(:get)
      .with(course.slug)
      .and_return(course)
  end

  describe 'show - GET /pathways/:id' do
    context 'unauthenticated' do
      it 'loads the course page' do
        get course_path(:en, course.slug)

        expect(response).to be_successful
        expect(response).to render_template(:show)

        expect(assigns(:course)).to eq course
        expect(assigns(:reactions)).to be nil
        expect(assigns(:progress)).to be nil
      end
    end

    it_behaves_like 'authenticated' do
      it 'loads the course page' do
        get course_path(:en, course.slug)

        expect(response).to be_successful
        expect(response).to render_template(:show)

        expect(assigns(:course)).to eq course
        expect(assigns(:reactions)).to eq({})
        expect(assigns(:progress)).to match_array([])
      end

      context 'with an existing reaction and progress' do
        before do
          create :note_reaction,
            course_slug: course.slug,
            lesson_slug: 'foo',
            reaction_name: 'strong',
            user: current_user

          create :progress,
            course_slug: course.slug,
            lesson_slug: 'foo',
            user: current_user
        end

        it 'loads the course page with the reactions and progresses' do
          get course_path(:en, course.slug)

          expect(response).to be_successful
          expect(response).to render_template(:show)

          expect(assigns(:reactions)).to eq(
            'foo' => 'strong'
          )
          expect(assigns(:progress)).to match_array(['foo'])
        end
      end
    end
  end
end
