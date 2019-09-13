module VotesHelper

  def heart_fill

    # Are these the right colours & update to pull from bootstrap

    return @voted ?  '#F4A5A6' : '#4490CE'

  end

end
