class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :set_target_user, only: [:show, :destroy, :edit, :update]
  # before_action :admin_user,     only: :destroy
  
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
      redirect_to @user
    else
      render 'new'
    end
  end

  def show
    @tasks = @user.tasks.page(params[:page]).per(8)
    # @tasks = Task.page(params[:page]).per(5)
    # @tasks = @user.tasks.page(page: params[:page])
  end

  def destroy
    @user.destroy
    flash[:success] = "退会しました。ご利用ありがとうございました！"
    redirect_to root_url
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "変更しました"
      redirect_to @user
      # 更新に成功した場合を扱う。
    else
      render 'edit'
    end
  end

    private
    #ストロングパラメーター
    def user_params
      params.require(:user).permit(:name, :email,:password,
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
