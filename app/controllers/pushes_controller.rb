class PushesController < ApplicationController

  before_action :signed_in_user

  def new
    @push = current_user.pushes.build if signed_in?
  end

  def create
    raise "Tagging".to_yaml
  end

  def show

  end

end
