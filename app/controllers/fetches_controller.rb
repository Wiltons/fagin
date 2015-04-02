class FetchesController < ApplicationController
  def create
    fullFetch = false
    @fetch = current_user.fetches.create(fetch_params)
    if @fetch.full_fetch or current_user.fetches.count < 2
      fullFetch=true
      @fetch.delay.populate_articles
    else
      @fetch.populate_articles
    end
    if !fullFetch && @fetch.articles.empty?
      flash[:notice] = "No new articles to fetch"
    elsif fullFetch
      flash[:notice] = "Queueing full fetch - this will take some time"
    else
      flash[:success] = "Successfully fetched #{@fetch.articles.count} articles!"
    end
    redirect_to root_url
  end

  def destroy
  end

  private

    def fetch_params
      params.require(:fetch).permit(:full_fetch)
    end

end
