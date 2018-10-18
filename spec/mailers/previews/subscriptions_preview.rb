# Preview all emails at http://localhost:3000/rails/mailers/subscriptions
class SubscriptionsPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/subscriptions/signup
  def signup
    SubscriptionsMailer.signup
  end

  # Preview this email at http://localhost:3000/rails/mailers/subscriptions/lesson
  def lesson
    SubscriptionsMailer.lesson
  end

  # Preview this email at http://localhost:3000/rails/mailers/subscriptions/complete
  def complete
    SubscriptionsMailer.complete
  end

  # Preview this email at http://localhost:3000/rails/mailers/subscriptions/paused
  def paused
    SubscriptionsMailer.paused
  end
end
