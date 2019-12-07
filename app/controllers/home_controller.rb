class HomeController < ApplicationController
  MAX_POST = 12

  def about
  end

  def index
    if user_signed_in?
      @feed_items = current_user.feed.page(params[:page]).per(MAX_POST).order(created_at: "DESC")
    end
  end
end
