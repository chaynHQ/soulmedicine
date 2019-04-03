class AddDisguisedFlagToSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_column :subscriptions, :disguised, :boolean, default: false
  end
end
