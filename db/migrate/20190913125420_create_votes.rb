class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes, id: :uuid do |t|
      t.references :user, foreign_key: true, type: 'uuid'
      t.string :course_slug, null: false
      t.index %i[user_id course_slug], unique: true
      t.index :course_slug
      t.timestamps
    end
  end
end
