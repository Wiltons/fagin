class PushesController < ApplicationController

  before_action :signed_in_user

  def new
    @push = current_user.pushes.build if signed_in?
  end

  def create
    if signed_in?
      @push = current_user.pushes.create(push_params)
      if @push.save
        flash[:success] = "Push created successfully"
        if params[:commit] == "Save and Create New"
          redirect_to push_path
        else
          @push.tag_articles unless params[:commit] == "Save"
          redirect_to pushes_path
        end
      else
        flash[:error] = "Errors exist"
        render 'new'
      end
    end
  end

  def show

  end

  def index
    @pushes = Push.paginate(page: params[:page])
  end

  private

    def push_params
      params.require(:push).permit!
    end

end
