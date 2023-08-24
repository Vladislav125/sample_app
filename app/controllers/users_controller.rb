class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.order(:name).page params[:page]
    # @users = User.paginate(:page => params[:page], per_page: 10)
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render :new, status: :unprocessable_entity, content_type: "text/html"
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "Profile updated!"
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity, content_type: "text/html"
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # предварительные фильтры

    # подтвверждает вход пользователя
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_path
      end
    end

    # подтверждает права пользователя
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    # подтверждает наличие административных привилегий
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
