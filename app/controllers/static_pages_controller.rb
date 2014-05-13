class StaticPagesController < ApplicationController
  def home
    @article = current_user.articles.build if signed_in?
    @fetch = current_user.fetches.build if signed_in?
  end

  def help
  end

  def contact
  end
end
