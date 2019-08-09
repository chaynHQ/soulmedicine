class AdminController < ApplicationController
  def flush_cache
    STORYBLOK_CLIENT.flush

    render inline: 'DONE', status: :ok
  end
end
