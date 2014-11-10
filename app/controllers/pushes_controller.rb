class PushesController < ApplicationController

  before_action :signed_in_user

  def new
    @push = current_user.pushes.build
  end

  def create
    @push = current_user.pushes.create(push_params)
    if @push.save
      if params[:commit] == "Save and Create New"
        flash[:success] = "Rule created"
        redirect_to new_push_path
      elsif params[:commit] == "Save and Run"
        commit_push
        flash[:success] = "Running rule to tag #{@push.source_tag_name} #{@push.comparator} #{@push.article_length} mins with tag '#{@push.destination_tag_name}'"
        flash[:warning] = "<a href=#{url_for pushes_undo_path(@push)}>Click here to undo</a>".html_safe
        redirect_to push_path(@push.id)
      else
        redirect_to pushes_path
      end
    else
      flash[:error] = "Errors exist"
      render :new
    end
  end

  def show
    @push=current_user.pushes.find(params[:id])
    @articles = @push.collect_articles
  end

  def index
    @pushes = current_user.pushes.paginate(page: params[:page])
  end

  def destroy
    delete_push = current_user.pushes.find(params[:id])
    delete_push.undo_commit
    flash[:success] = "Rule deleted: Tagging #{delete_push.source_tag_name} articles #{delete_push.comparator} #{delete_push.article_length} minutes long with tag #{delete_push.destination_tag_name}"
    delete_push.destroy
    redirect_to pushes_path
  end

  def undo
    undo_push = current_user.pushes.find(params[:id])
    undo_push.undo_commit ? 
      flash[:success] = "Rule commit successfully undone" : 
      flash[:error] = "Rule commit cannot be undone (Already undone or committed to Pocket)"
    redirect_to push_path(undo_push)
  end

  def run
    @push = current_user.pushes.find(params[:id])
    commit_push
    flash[:success] = "Running rule to tag #{@push.source_tag_name} #{@push.comparator} #{@push.article_length} mins with tag '#{@push.destination_tag_name}'"
    flash[:warning] = "<a href=#{url_for pushes_undo_path(@push)}>Click here to undo</a>".html_safe
    redirect_to push_path(@push)
  end

  private

    def push_params
      params.require(:push).permit!
    end

    def commit_push
      @push.delay(run_at: 10.seconds.from_now, queue: @push.push_hash).tag_articles
    end

end
