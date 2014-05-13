class FetchesController < ApplicationController
  def create
    @fetch = current_user.fetches.build
    if @fetch.save
      flash[:success] = "Fetch successful"
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end

  def destroy
    raise "DESTROY".to_yaml
  end
end
