class AddStatusToCourse < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :status, :integer
  end
end
