class AddUserTimezoneToSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_column :subscriptions, :user_timezone, :string, default: 'UTC'
  end
end
