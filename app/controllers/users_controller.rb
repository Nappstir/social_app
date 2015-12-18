class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :index, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_path
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

  # BEFORE FILTERS

  # Confirms user is logged in
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in"
        redirect_to login_path
      end
    end

  # Confirms only logged in user can edit/update themselves
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

  # Confirms admin user
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end
