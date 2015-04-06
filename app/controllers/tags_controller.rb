class TagsController < ApplicationController

  before_action :signed_in_user

  def create
  end

  def index
    tags = current_user.tags.to_a.group_by(&:name).map{|k,v| v.first}
    tags.sort_by! { |t| t.name.downcase }
    @tags = tags.paginate(page: params[:page])
  end

  def show
    @tag=current_user.tags.find(params[:id])
    @my_articles = current_user.articles.includes(:tags).where(tags: {id: @tag.id}).paginate(page: params[:page])
  end

end
