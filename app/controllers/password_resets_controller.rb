class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expiration,
    only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase

    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".email_sent"
      redirect_to root_url
    else
      flash.now[:danger] = t ".email_not_found"
      render :new
    end
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, t(".can_not_be_empty")
      render :edit
    elsif @user.update_attributes user_params
      flash[:success] = t ".has_reset"
      redirect_to @user
    else
      render :edit
    end
  end

  def edit
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def load_user
    @user = User.find_by email: params[:email]

    return if @user
    flash[:danger] = t ".not_found"
    redirect_to root_url
  end

  def valid_user
    return if (@user && @user.activated? &&
      @user.authenticated?(:reset, params[:id]))
      redirect_to root_url
  end

  def check_expiration
    return if not @user.password_reset_expired?
    flash[:danger] = t ".has_expired"
    redirect_to new_password_reset_url
  end
end
