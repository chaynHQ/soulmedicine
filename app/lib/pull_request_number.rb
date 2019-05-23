class PullRequestNumber
  def self.call
    new.call
  end

  def initialize(from = ENV['HEROKU_APP_NAME'])
    @from = from
  end

  def call
    @from.try(:[], /-(pr-\d+$)/, 1)
  end
end
