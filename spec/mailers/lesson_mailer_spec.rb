require 'rails_helper'

RSpec.describe LessonMailer, :type => :mailer do
  describe 'send_lesson' do
    let(:user) { create :user }
    let(:course) { load_course('course-1.json') }
    let(:lesson) { course.lessons.first}
    let(:mail) { described_class.lesson_email(user: user, course: course, lesson: lesson, languages: ['en', 'ar'], disguised: false) }
    before do
      allow(URI).to receive_message_chain(:parse, :read).and_return('picture_as_url')
    end

    it "renders the mail" do
      expect(mail.subject).to eq(lesson.name)
      expect(mail.to).to eq([user.email])
    end

  end

  describe 'disguised_subject_line' do
    let(:user) { create :user }
    let(:course) { load_course('course-1.json') }
    let(:lesson) { course.lessons.first}
    let(:disguised_mail) { described_class.lesson_email(user: user, course: course, lesson: lesson, languages: ['en', 'ar'], disguised: true) }
    before do
      allow(URI).to receive_message_chain(:parse, :read).and_return('picture_as_url')
    end

    it 'returns a disguised subject line' do
      expect(disguised_mail.subject).not_to eq(lesson.name)
    end
  end
end
