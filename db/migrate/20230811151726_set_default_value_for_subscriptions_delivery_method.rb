class SetDefaultValueForSubscriptionsDeliveryMethod < ActiveRecord::Migration[5.2]
  def change
    change_column_default :subscriptions, :delivery_method, from: nil, to: 'email'
  end
end
