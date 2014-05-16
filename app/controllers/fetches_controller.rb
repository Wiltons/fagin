class FetchesController < ApplicationController
  def create
    @fetch = current_user.fetches.build(fetch_params)
    raise @fetch.to_yaml
    if @fetch.save
      flash[:success] = "Fetch successful"
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end

  def destroy
  end

  private

    def fetch_params
      params.require(:fetch).permit(:full_fetch)
    end

end