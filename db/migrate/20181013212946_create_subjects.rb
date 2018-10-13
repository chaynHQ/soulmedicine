class CreateSubjects < ActiveRecord::Migration[5.2]
  def change
    create_table :subjects do |t|
      t.references :course, foreign_key: true
      t.integer :sequential_id
      t.integer :status
      t.boolean :approved

      t.timestamps
    end
    reversible do |dir|
      dir.up do
        Subject.create_translation_table!({
          :name => :string,
          :description => :string,
          :notes => :string
        })
      end

      dir.down do
        Subject.drop_translation_table!
      end
    end
  end
end
