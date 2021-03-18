class MacsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  skip_before_action :verify_authenticity_token

  def index
  end

  def show
    @macs = current_user.macs
  end

  def new
    @mac = current_user.macs.new
  end

  def create
    @mac = current_user.macs.build(mac_params)
    if @mac.save
      flash[:success] = "目標｢#{@mac.measurable}｣を作成しました!"
      redirect_to mac_path(current_user)
    else
      render 'macs/new'
    end
  end

  def edit
    @mac = current_user.macs.find(params[:id])
  end

  def update
    if current_user.macs.update(mac_params)
      flash[:success] = "編集しました!"
      redirect_to mac_path(current_user)
    else
      render 'macs/edit'
      end
  end

  def destroy
    @mac.destroy
    redirect_to request.referrer || root_url
  end

  private
  # ストロングパラメーター
  def mac_params
    params.require(:mac).permit(:measurable, :actionable, :competent)
  end

  # 現在のユーザーが削除対象のmacを保有しているかどうかを確認します。
  def correct_user
    @mac = current_user.macs.find_by(id: params[:id])
    redirect_to root_url if @mac.nil?
  end
end
