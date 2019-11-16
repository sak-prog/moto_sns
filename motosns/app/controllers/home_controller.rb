class HomeController < ApplicationController
  def about
  end

  def index
    if user_signed_in?
      @feed_items = current_user.feed.all
    end
  end
end
