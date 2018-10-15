class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.references :user, foreign_key: true
      t.references :course, foreign_key: true
      t.references :subject, foreign_key: true
      t.references :lesson, foreign_key: true
      t.boolean :active
      t.integer :delivery_method
      t.time :delivery_time_of_day
      t.integer :delivery_frequency

      t.timestamps
    end
  end
end
