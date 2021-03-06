class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in(user)
        params[:session][:remember_me] == "1" ? remember(user) : forget(user)
        redirect_back_or user
      else
        flash[:warning] = "Account not activated. Check email for activation link."
        redirect_to root_path
      end
    else
      # Create an error
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
  end

  def destroy
    # Handles user logout in 1 of 2 windows on same browser
    log_out if logged_in?
    redirect_to root_path
  end
end
