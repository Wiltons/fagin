class StaticPagesController < ApplicationController
  def home
    @fetch = current_user.fetches.build if signed_in?
  end

  def help
  end

  def contact
  end
end
