class PushesController < ApplicationController

  before_action :signed_in_user

  def new
    @push = current_user.pushes.build if signed_in?
  end

  def create
    if signed_in?
      tag_items = Array.new
      current_user.fetches.each do |fetch|
        fetch.articles.each do |article|
          tag_items << article.item_id if article.word_count > 1000
        end
      end
      redirect_to push_path
    end
  end

  def show

  end

end
