class CreateLessonReaction < ActiveRecord::Migration[5.2]
  def change
    create_table :lesson_reactions, id: :uuid do |t|
      t.references :user, foreign_key: true, type: 'uuid'
      t.string :course_slug, null: false
      t.string :lesson_slug, null: false
      t.string :reaction_name, null: false
      t.index %i[user_id course_slug]
      t.index %i[user_id course_slug lesson_slug], unique: true, name: 'index_lesson_reactions_on_user_id_and_course_and_lesson_slug'
      t.timestamps
    end
  end
end
