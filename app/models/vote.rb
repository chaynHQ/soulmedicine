class Vote < ApplicationRecord
  belongs_to :user

  validates :course_slug,
    presence: true,
    uniqueness: { scope: :user_id }

  def self.get_course_vote_total(course_slug)
    Vote.where(course_slug: course_slug).count
  end

  def self.course_totals(course_slugs)
    votes = Vote
      .where(course_slug: course_slugs)
      .group(:course_slug)
      .count

    course_slugs.each_with_object({}) do |cs, acc|
      acc[cs] = votes[cs] || 0
    end
  end
end
