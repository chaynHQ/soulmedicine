class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users, id: :uuid do |t|
      t.string :display_name, null: false
      t.string :firebase_id, null: false
      t.string :email, null: false
      t.boolean :email_verified, default: false
      t.datetime :last_seen_at

      t.timestamps

      t.index :firebase_id, unique: true
      t.index :email, unique: true
    end
  end
end
