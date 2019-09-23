module VotesHelper

  def heart_fill

    return @voted ?  'fas fa-heart' : 'far fa-heart'

  end

end
