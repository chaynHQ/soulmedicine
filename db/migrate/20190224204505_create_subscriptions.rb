class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions, id: :uuid do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.string :course_slug, null: false
      t.boolean :active, null: false, default: false
      t.string :main_language, null: false
      t.string :other_languages, array: true, null: false, default: []
      t.string :delivery_method, null: false
      t.string :days_utc, array: true, null: false, default: []
      t.integer :hours_utc, array: true, null: false, default: []
      t.string :lessons_delivered, array: true, default: []
      t.datetime :last_delivered_at

      t.timestamps

      t.index %i[user_id course_slug], unique: true
      t.index :active
    end
  end
end
