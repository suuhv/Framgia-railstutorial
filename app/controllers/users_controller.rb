class UsersController < ApplicationController
  before_action :logged_in_user, except: [:show, :new, :create]
  before_action :load_user, except: [:index, :new, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :verify_admin, only: :destroy

  def index
    @users = User.select(:id, :name, :email).order(:id).paginate page: params[:page],
      per_page: Settings.user.page_size
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash[:info] = t ".check_mail"
      redirect_to root_url
    else
      flash.now[:danger] = t ".error"
      render :new
    end
  end

  def show
    @microposts = @user.microposts.paginate page: params[:page],
      per_page: Settings.user.page_size
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".success"
      redirect_to @user
    else
      flash.now[:danger] = t ".error"
      render :edit
    end
  end

  def destroy
    @user.destroy ? flash[:success] = t(".deleted") : flash.now[:error] = t(".er")
    redirect_to users_url
  end

  def following
    @title = t ".following"
    @user = User.find_by id: params[:id]
    @users = @user.following.paginate page: params[:page]
    render "show_follow"
  end

  def followers
    @title = t ".followers"
    @user = User.find_by id: params[:id]
    @users = @user.followers.paginate page: params[:page]
    render "show_follow"
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  def load_user
    @user = User.find_by id: params[:id]

    return if @user
    render file: "public/404.html", layout: false
  end

  def correct_user
    redirect_to root_url unless @user.current_user? current_user
  end

  def verify_admin
    redirect_to root_url unless current_user.is_admin?
  end
end
