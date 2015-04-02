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
    article_ids = Tag.where(name: @tag.name)
# This is absolute nonsense
    @tags=Article.where(id: article_ids).paginate(page: params[:page])
    @articles = Article.where(id: article_ids)
    article_lengths = @articles.map(&:word_count)
    @avg_len = (article_lengths.sum / article_lengths.size)
  end

end
