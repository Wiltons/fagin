class StaticPagesController < ApplicationController
  def home
  end

  def help
  end

  def about
    @articles=current_user.articles
  end

  def contact
  end
end
