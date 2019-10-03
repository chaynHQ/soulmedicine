class CreateBackups < ActiveRecord::Migration[5.2]
  def change
    create_table :backups, id: :uuid do |t|
      t.string :key, null: false
      t.jsonb :data, null: false, default: {}

      t.timestamps
      t.index :key, unique: true
    end
  end
end
