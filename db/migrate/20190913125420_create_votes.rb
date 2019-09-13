class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes, id: :uuid do |t|
      t.references :user, foreign_key: true, type: 'uuid'
      t.string :course_slug, null: false
      t.boolean :liked, null: false, default: false

      t.timestamps
    end
  end
end
