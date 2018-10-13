class CreateLessons < ActiveRecord::Migration[5.2]
  def change
    create_table :lessons do |t|
      t.references :subject, foreign_key: true
      t.integer :sequential_id
      t.integer :status
      t.boolean :approved

      t.timestamps
    end
    reversible do |dir|
      dir.up do
        Lesson.create_translation_table!({
          :content => :string,
          :notes => :string
        })
      end

      dir.down do
        Lesson.drop_translation_table!
      end
    end
  end
end
