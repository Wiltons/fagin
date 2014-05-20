class SessionsController < ApplicationController

  def new
  end

  def create
    auth = request.env["omniauth.auth"]
    remember_token = cookies[:remember_token]
    if User.find_by_uid(auth["uid"])
      user = User.find_by_uid(auth["uid"])
      newuser = false 
    else
      user = User.create_with_omniauth(auth)
      newuser = true
    end
    session[:user_id] = user.id
    sign_in(user)
    if newuser
      flash[:success] = "Welcome to Fagin!"
      redirect_to edit_user_path(current_user)
    else
      user.fetches.build(full_fetch: false).save! unless user.fetches.empty?
      flash[:success] = "Welcome back!"
      redirect_to root_url
    end
  end

  def destroy
    sign_out
    redirect_to root_url
    flash[:success] = "Successfully signed out!"
  end

  def failure
    flash[:error] = "Pocket authentication failed"
    redirect_to root_url
  end

end
