class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  #リファクタリング用
  before_action :set_target_user, only: [:show, :destroy, :edit, :update]
  before_action :admin_user,     only: :destroy

  def index
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

  # userに紐付いたタスクを返す
  def show

  end

  def destroy
    User.find(params[:id]).destroy
      flash[:success] = "退会しました。#{@user.name}さん。ご利用ありがとうございました！"
      redirect_to root_path
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "変更しました"
      redirect_to @user
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
    redirect_to(root_url) unless current_user?(@user)
  end

  # 管理者かどうか確認する
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
