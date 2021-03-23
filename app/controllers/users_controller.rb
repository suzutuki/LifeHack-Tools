class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  #リファクタリング用
  before_action :set_target_user, only: [ :destroy, :edit, :update]
  before_action :admin_user, only: [:destroy, :show]
  skip_before_action :verify_authenticity_token
  def index
  end

  def show
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "ユーザー登録に成功しました!"
      redirect_to root_path
    else
      render 'new'
    end
  end

  def easy_login
    user = User.find_or_create_by(email: 'guest@example.com')
    user.name = "GuestUser"
    user.password = SecureRandom.urlsafe_base64
    user.save if !user.id
    log_in(user)
    redirect_to root_path
    flash[:notice] = "ゲストユーザーとしてログインしました!"
  end

  def destroy
    @user.destroy
    flash[:success] = "退会しました。ご利用ありがとうございました！"
    redirect_to root_path
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を変更しました！"
      redirect_to root_path
    else
      render 'edit'
    end
  end

  private

  #ストロングパラメーター
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  #リファクタリング用
  def set_target_user
    @user = User.find(params[:id])
  end

  # 正しいユーザーかどうか確認する
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user) && !guest_user
  end

  # 管理者かどうか確認する
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
