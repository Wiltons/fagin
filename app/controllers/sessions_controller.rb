class SessionsController < ApplicationController

  def new
  end

  def create
    auth = request.env["omniauth.auth"]
    token = cookies[:remember_token]
    user = User.find_by_uid(auth["uid"]) || User.create_with_omniauth(auth,token)
    session[:user_id] = user.id
    redirect_to root_url, :notice => "Signed in!"
  end

  def destroy
    sign_out
    redirect_to root_url
    flash[:success] = "Successfully signed out!"
  end

  def failure
    User.destroy(current_user)
    redirect_to signup_path
    flash[:error] = "Pocket authentication error."
  end

end
