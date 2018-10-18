class DropSubjects < ActiveRecord::Migration[5.2]
  def change
    drop_table :subjects
  end
end
