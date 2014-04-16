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
      redirect_to '/auth/pocket', status: 301
#      @user = User.new(user_params)
#      if @user.save
#        sign_in @user
#        flash[:success] = "Welcome to the app!"
#        redirect_to (root_url)
#      else
#        flash[:error] = "Signup error"
#        render 'new'
#      end
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
