class CreateLanguages < ActiveRecord::Migration[5.2]
  def change
    create_table :languages do |t|
      t.string :name, null: false
      t.boolean :active, default: true, null: false
      t.string :locale, null: false

      t.timestamps
    end
  end
end
