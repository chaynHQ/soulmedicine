class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.integer :sequential_id
      t.boolean :active
      t.boolean :approved
      t.references :owner, foreign_key: {to_table: :users}
      t.timestamps
    end
    reversible do |dir|
      dir.up do
        Course.create_translation_table!({
          :name => :string,
          :description => :string,
          :notes => :string
        })
      end

      dir.down do
        Course.drop_translation_table!
      end
    end
  end
end
