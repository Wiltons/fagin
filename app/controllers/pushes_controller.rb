class PushesController < ApplicationController

  before_action :signed_in_user

  def new
    @push = current_user.pushes.build if signed_in?
  end

  def create
    if signed_in?
      @push = current_user.pushes.create
      redirect_to push_path
    end
  end

  def show

  end

  def index

  end

end
