class PushesController < ApplicationController

  before_action :signed_in_user

  def new
    @push = current_user.pushes.build
  end

  def create
    @push = current_user.pushes.create(push_params)
    if @push.save
      flash[:success] = "Rule created successfully"
      if params[:commit] == "Save and Create New"
        redirect_to new_push_path
      elsif params[:commit] == "Save and Run"
        redirect_to articles_path
      else
        redirect_to pushes_path
      end
    else
      flash[:error] = "Errors exist"
      render :new
    end
  end

  def show
    run_push = current_user.pushes.find(params[:id])
    run_push.tag_articles
    flash[:success] = "Successfully Ran! (#{run_push.source_tag_name} #{run_push.comparator} #{run_push.article_length} mins with tag #{run_push.destination_tag_name})"
    redirect_to pushes_path
  end

  def index
    @pushes = current_user.pushes.paginate(page: params[:page])
  end

  def commit
    raise "test".to_yaml
  end

  def destroy
    delete_push = current_user.pushes.find(params[:id])
    flash[:success] = "Rule deleted: Tagging #{delete_push.source_tag_name} articles #{delete_push.comparator} #{delete_push.article_length} minutes long with tag #{delete_push.destination_tag_name}"
    delete_push.destroy
    redirect_to pushes_path
  end

  private

    def push_params
      params.require(:push).permit!
    end

end
