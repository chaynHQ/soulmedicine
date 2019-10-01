require 'rails_helper'

RSpec.describe Vote, type: :model do
  let(:slug) { 'diy-online-safety' }
  let(:nonexistent_slug) {'nonexistent-slug'}


  before do
    create_list(:vote, 2, course_slug: 'diy-online-safety')
  end

  describe '#get_course_vote_total' do

    context 'when course_slug does not exist' do
      it 'returns 0' do
        expect(Vote.get_course_vote_total(nonexistent_slug)).to be 0
      end
    end

    context 'when course_slug exists' do
      it 'returns 0' do
        expect(Vote.get_course_vote_total(slug)).to be 2
      end
    end

  end

  describe '#course_totals' do
    context 'when there are no course_slugs' do
      it 'returns an empty dict' do
        expect(Vote.course_totals([])).to be {}
      end
    end

    context 'when one of the course_slugs does not exist' do
      it 'should return 0 in the dict for non-existent slugs' do
        expect(Vote.course_totals([slug, nonexistent_slug])).to include(
          'diy-online-safety'=> 2,
          'nonexistent-slug'=> 0
        )

      end
    end

    context 'when all of the course_slugs exist and have votes' do
      it 'should return correct totals' do
        expect(Vote.course_totals([slug])).to include(
          'diy-online-safety'=> 2,
        )
      end
    end

  end

end
