require 'rails_helper'

RSpec.describe CoursesService, type: :service do
  let(:storyblok_client) { instance_double 'Storyblok::Client' }

  subject { described_class.new storyblok_client }

  def load_json(filename)
    JSON.parse file_fixture(filename).read
  end

  let(:api_response) { { 'data' => data } }

  describe '#list' do
    before do
      allow(storyblok_client).to receive(:stories)
        .with(
          starts_with: 'courses',
          excluding_fields: 'lessons'
        )
        .and_return(api_response)
    end

    context 'with no courses' do
      let(:data) { { 'stories' => [] } }

      it 'returns an empty list' do
        expect(subject.list).to eq []
      end
    end

    context 'with courses' do
      let(:data) { load_json('courses-list.json') }

      let :expected_courses do
        [
          Course.new(
            slug: 'diy-online-safety',
            uuid: '5896757a-6975-4a2f-9672-71583d99d42f',
            name: 'DIY: Online Safety'
          )
        ]
      end

      it 'maps the courses data to objects as expected' do
        expect(subject.list).to eq expected_courses
      end
    end
  end
end
