class AddPolicyAcceptedToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :policy_accepted, :boolean, default: false
  end
end
