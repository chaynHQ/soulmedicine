class RemoveSubjectFromLesson < ActiveRecord::Migration[5.2]
  def change
    remove_reference :lessons, :subject, foreign_key: true
  end
end
