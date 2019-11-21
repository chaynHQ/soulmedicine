class CreateProgress < ActiveRecord::Migration[5.2]
  def change
    create_table :progresses, id: :uuid do |t|
      t.references :user, foreign_key: true, type: 'uuid'
      t.string :course_slug, null: false
      t.string :lesson_slug, null: false
      t.index %i[user_id course_slug]
      t.index %i[user_id course_slug lesson_slug], unique: true
      t.timestamps
    end
  end
end
