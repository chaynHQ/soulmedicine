require 'rails_helper'

RSpec.describe SubscriptionsProcessorService, type: :service do
  include_context 'time helpers'
  include_context 'courses_service double'

  before do
    allow(courses_service).to receive(:get)
      .with(anything)
      .and_return(course)
  end

  let :course do
    instance_double 'Course',
      slug: 'my-existing-course',
      enabled_languages: %w[en ar]
  end

  describe '#run' do
    subject { SubscriptionsProcessorService.new }

    shared_examples 'does not deliver anything' do
      it 'does not deliver anything' do
        expect(subject).to receive(:deliver).never
        expect(LessonMailer).to receive(:lesson_email).never

        subject.run
      end
    end

    context 'with no subscriptions' do
      include_examples 'does not deliver anything'
    end

    context 'with no active subscriptions' do
      before do
        create_list :subscription, 2,
          active: false,
          course_slug: course.slug,
          main_language: course.enabled_languages.first

        expect(subject).to receive(:process).never
      end

      include_examples 'does not deliver anything'
    end

    context 'with active subscriptions' do
      let! :subscription do
        create :subscription,
          active: true,
          course_slug: course.slug,
          main_language: course.enabled_languages.first,
          other_languages: [course.enabled_languages.second],
          days_utc: [Time.now.utc.strftime('%a')],
          hours_utc: [Time.now.utc.hour],
          last_delivered_at: 2.hours.ago
      end

      context 'with an unverified user email' do
        before do
          subscription.user.update! email_verified: false
        end

        include_examples 'does not deliver anything'
      end

      context 'when course does not exist' do
        before do
          subscription.user.update! email_verified: true

          allow(courses_service).to receive(:get)
            .with(anything)
            .and_return(nil)

          expect(subject).to receive(:course_ok?)
            .and_call_original
        end

        include_examples 'does not deliver anything'
      end

      context 'when course exists' do
        before do
          subscription.user.update! email_verified: true
        end

        context 'not within schedule' do
          before do
            days_utc = 1.day.from_now.utc.strftime('%a')
            subscription.update! days_utc: [days_utc]

            expect(subject).to receive(:course_ok?).never

            expect(subject).to receive(:within_schedule?)
              .and_call_original
          end

          include_examples 'does not deliver anything'
        end

        context 'already delivered within the last hour' do
          before do
            subscription.update! last_delivered_at: 50.minutes.ago

            expect(subject).to receive(:course_ok?).never

            expect(subject).to receive(:deliver_subscription_now?)
              .and_call_original
          end

          include_examples 'does not deliver anything'
        end

        context 'allowed to be delivered right now' do
          let(:lesson) { instance_double('Lesson', slug: 'lesson-1') }

          let! :other_subscription do
            create :subscription,
              active: true,
              course_slug: course.slug,
              main_language: course.enabled_languages.first,
              days_utc: [1.day.from_now.utc.strftime('%a')],
              hours_utc: [Time.now.utc.hour],
              last_delivered_at: 2.hours.ago
          end

          before do
            other_subscription.user.update! email_verified: true

            expect(subject).to receive(:course_ok?)
              .at_least(:once)
              .and_call_original
          end

          it 'delivers the lesson email for just that subscription' do
            expect(subject).to receive(:deliver)
              .with(subscription)
              .once
              .and_call_original
            expect(subject).to receive(:deliver)
              .with(other_subscription)
              .never

            expect(course).to receive(:next_lesson)
              .and_return(lesson)

            email = double
            expect(LessonMailer).to receive(:lesson_email)
              .with(
                user: subscription.user,
                course: subscription.course,
                lesson: lesson,
                languages: [subscription.main_language] + subscription.other_languages,
                disguised: subscription.disguised
              )
              .and_return(email)
            expect(email).to receive(:deliver_now)

            subject.run
          end
        end
      end
    end
  end
end
