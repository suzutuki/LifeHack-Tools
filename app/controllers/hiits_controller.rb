class HiitsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def index
  end

  def create
    @hiit = current_user.hiits.build(hiit_params)
    if @hiit.save
      flash[:success] = "作成しました!"
      redirect_to hiit_path(current_user)
    else
      render 'hiits/new'
    end
  end

  def update
    if current_user.hiits.update(hiit_params)
      flash[:success] = "編集しました!"
      redirect_to hiit_path(current_user)
    else
      render 'hiits/edit'
    end
  end

  def destroy
    @hiit.destroy
    redirect_to request.referrer || root_url
  end


  def new
    @hiit = current_user.hiits.new
  end

  def edit
    @hiit = current_user.hiits.find(params[:id])
  end

  def show
    @user = current_user
    @hiits = current_user.hiits
    @graphdays =  @user.hiits.order(training_day: "DESC").limit(6).reverse
    @dayline = Array.new
    @graphdays.each do |graphday|
      @dayline.push(graphday.training_day.strftime('%m/%d').to_s)
    end
    @graphtimes =  @user.hiits.order(training_day: "DESC").limit(6).reverse
    @timeline = Array.new
    @graphtimes.each do |graphtime|
      @timeline.push(graphtime.training_time)
    end
  end

  private
  # ストロングパラメーター
  def hiit_params
    params.require(:hiit).permit(:training_day, :training_time)
  end

  # 現在のユーザーが削除対象のhiitを保有しているかどうかを確認します。
  def correct_user
    @hiit = current_user.hiits.find_by(id: params[:id])
    redirect_to root_url if @hiit.nil?
  end
end