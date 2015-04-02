class TagsController < ApplicationController

  before_action :signed_in_user

  def create
  end

  def index
    @tags = current_user.tags.select(:name).distinct.paginate(page: params[:page])
  end

  def show
  end

end
