class ItsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy
  before_action :correct_user_destroy_all, only: :destroy_all
  skip_before_action :verify_authenticity_token

  def index
  end

  def show
    @its = current_user.its.page(params[:page]).per(10)
  end

  def new
    @its = ItCollection.new(current_user)
  end

  def create
    @its = ItCollection.new(current_user, its_params)
    if @its.save
      flash[:success] = "作成しました！"
      redirect_to it_path(current_user)
    else
      render 'its/new'
    end
  end

  def edit
  end

  def update
    if current_user.update(user_its_params)
      flash[:success] = "編集しました!"
      redirect_to it_path(current_user)
    else
      render 'its/edit'
    end
  end

  def destroy
    @it.destroy
    flash[:danger] = "#{@it.situation}削除しました!"
    redirect_to request.referrer || root_url
  end

  # 一括削除
  def destroy_all
    @its.destroy_all
    flash[:danger] = "全て削除しました!"
    redirect_to request.referrer || root_url
  end

  private

  # ストロングパラメーターcreate用
  def its_params
    params.require(:its)
  end

  # ストロングパラメーターupdate用
  def user_its_params
    params.require(:user).permit(its_attributes: [:situation, :behavior, :id])
  end

  # 現在のユーザーが削除対象のitを保有しているかどうかを確認します。
  def correct_user
    @it = current_user.its.find_by(id: params[:id])
    redirect_to root_url if @it.nil?
  end

  # 現在のユーザーが削除対象のitsを保有しているかどうかを確認します。
  def correct_user_destroy_all
    @its = current_user.its
    redirect_to root_url if @its.nil?
  end

end