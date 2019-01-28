class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :display_name
      t.string :uid
      t.string :email

      t.timestamps
    end
  end
end
