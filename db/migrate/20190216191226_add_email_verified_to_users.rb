class AddEmailVerifiedToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :email_verified, :boolean
  end
end
