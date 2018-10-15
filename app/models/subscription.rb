# == Schema Information
#
# Table name: subscriptions
#
#  id                   :bigint(8)        not null, primary key
#  active               :boolean
#  delivery_frequency   :integer
#  delivery_method      :integer
#  delivery_time_of_day :time
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  course_id            :bigint(8)
#  lesson_id            :bigint(8)
#  subject_id           :bigint(8)
#  user_id              :bigint(8)
#
# Indexes
#
#  index_subscriptions_on_course_id   (course_id)
#  index_subscriptions_on_lesson_id   (lesson_id)
#  index_subscriptions_on_subject_id  (subject_id)
#  index_subscriptions_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#  fk_rails_...  (lesson_id => lessons.id)
#  fk_rails_...  (subject_id => subjects.id)
#  fk_rails_...  (user_id => users.id)
#
class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :course
  belongs_to :subject
  belongs_to :lesson

  enum :delivery_method => %i[na email sms facebook whatsapp twitter]
  enum :delivery_frequency => %i[daily weekly biweekly monthly]
end
