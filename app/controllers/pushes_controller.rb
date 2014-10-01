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
    @push = current_user.pushes.find(params[:id])
    commit_push
    @articles = @push.collect_articles
    #flash[:success] = "Successfully running rule to tag #{@push.source_tag_name} #{@push.comparator} #{@push.article_length} mins with tag '#{@push.destination_tag_name}'"
  end

  def index
    @pushes = current_user.pushes.paginate(page: params[:page])
  end

  def destroy
    delete_push = current_user.pushes.find(params[:id])
    flash[:success] = "Rule deleted: Tagging #{delete_push.source_tag_name} articles #{delete_push.comparator} #{delete_push.article_length} minutes long with tag #{delete_push.destination_tag_name}"
    delete_push.destroy
    redirect_to pushes_path
  end

  def undo
    @push = current_user.pushes.find(params[:id])
    Delayed::Job.find_by(queue: push_hash).destroy
    redirect_to pushes_path
  end

  private

    def push_params
      params.require(:push).permit!
    end

    def commit_push
      @push.delay(run_at: 15.seconds.from_now, queue: push_hash).tag_articles
    end

    def push_hash
      push_details=""
      push_details << @push.source_tag_name << @push.destination_tag_name << @push.comparator << @push.article_length
      queue_name=Digest::SHA256.hexdigest push_details
    end

end
