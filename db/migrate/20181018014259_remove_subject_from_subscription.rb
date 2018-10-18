class RemoveSubjectFromSubscription < ActiveRecord::Migration[5.2]
  def change
    remove_reference :subscriptions, :subject, foreign_key: true
  end
end
