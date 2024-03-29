class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  #リファクタリング用
  before_action :set_target_user, only: [:destroy, :edit, :update]
  before_action :admin_user, only: [:show]

  def index
  end

  def how_to
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
      render "new"
    end
  end

  def easy_login
    user = User.find_or_create_by(email: "guest@example.com")
    user.name = "GuestUser"
    user.password = SecureRandom.urlsafe_base64
    user.save if !user.id
    log_in(user)
    redirect_to root_path
    flash[:notice] = "ゲストユーザーとしてログインしました!"
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を変更しました！"
      redirect_to root_path
    else
      render "edit"
    end
  end

  def destroy
    @user.destroy if correct_user || admin_user
    flash[:success] = "退会しました。ご利用ありがとうございました！"
  end

  private

  #ストロングパラメーター
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation, :image, :image_cache)
  end

  #リファクタリング用
  def set_target_user
    @user = User.find(params[:id])
  end

  # 正しいユーザーかどうか確認する
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  # 管理者かどうか確認する
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
