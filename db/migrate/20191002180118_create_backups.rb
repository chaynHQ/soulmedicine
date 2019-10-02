class CreateBackups < ActiveRecord::Migration[5.2]
  def change
    create_table :backups, id: :uuid do |t|
      t.references :user, foreign_key: true, type: 'uuid'
      t.string :key
      t.jsonb :data

      t.timestamps
      t.index :key, unique: true
    end
  end
end
