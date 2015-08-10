class JobsController < ApplicationController
  def index
    @fetch = current_user.fetches.last
  end

  def format
  end

  def status
    @fetch = current_user.fetches.last
    render json: {id: @fetch.id, finished: @fetch.finished }
  end
end
