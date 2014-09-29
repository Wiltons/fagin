class FetchesController < ApplicationController
  def create
    @fetch = current_user.fetches.create(fetch_params)
    if @fetch.full_fetch or current_user.fetches.count < 2
      @fetch.delay.populate_articles
    else
      @fetch.populate_articles
    end
    if @fetch.articles.empty?
      flash[:notice] = "No new articles to fetch"
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
