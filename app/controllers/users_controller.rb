class UsersController < ApplicationController
  before_action :signed_in_user,  only: [:index, :edit, :update, :destroy]
  before_action :correct_user,    only: [:edit, :update]
  before_action :admin_user,      only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    if signed_in?
      redirect_to(root_url)
    else
      @user = User.new
    end
  end

  def create
    if signed_in?
      redirect_to(root_url)
    else
      @user = User.new(user_params)
      if @user.save
        sign_in @user
        redirect_to ('/auth/pocket')
      else
        flash[:error] = "Signup error"
        render 'new'
      end
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    destroy_user = User.find(params[:id])
    if current_user?(destroy_user)
      redirect_to root_url
    else
      destroy_user.destroy
      flash[:success] = "User deleted"
      redirect_to users_url
    end
  end

  def destroy(user)
    user.destroy
  end

  def populate_articles
    since = params[:since].nil? ? 1000000000 : params[:since]
    uri=URI('https://getpocket.com/v3/get')
    req = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' => 'application/json'})
    req.body={"consumer_key" => ENV['pocket_key'],
              "access_token" => current_user.pocket_token,
              "since" => since }.to_json
    res = Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
      http.verify_mode= OpenSSL::SSL::VERIFY_NONE
      http.ssl_version= :SSLv3
      http.request req
    end
    article = JSON[res.body]
    current_user.last_fetch=Time.now.to_i
    current_user.save
    article["list"].each do |key, value|
      @article = current_user.articles.build(
                  item_id: key,
                  given_url: value["given_url"],
                  favorite: value["favorite"],
                  status: value["status"],
                  #given_title: value["given_title"],
                  word_count: value["word_count"])
      @article.save
    end
    if article["list"].blank?
      flash[:notice] = "No new articles saved since last fetch"
    else
      flash[:success] = "New articles fetched!"
    end
    redirect_to root_path
  end


  private

    def user_params
      params.require(:user).permit(:name, :email)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
