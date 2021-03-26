class HiitsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  skip_before_action :verify_authenticity_token

  def index
  end

  def show
    @user = current_user
    @hiits = @user.hiits
    @graphdays =  @user.hiits.order(training_day: "DESC").limit(1000).reverse
    @dayline = Array.new
    @graphdays.each do |graphday|
      @dayline.push(graphday.training_day.strftime('%Y/%m/%d').to_s)
    end
    @graphtimes =  @user.hiits.order(training_day: "DESC").limit(1000).reverse
    @timeline = Array.new
    @graphtimes.each do |graphtime|
      @timeline.push(graphtime.training_time)
    end
  end

  def create
    # if
    # hiit == current_user.hiits.select {|trainig_day| trainig_day }.sum
    # end
    @hiit = current_user.hiits.build(hiit_params)
    if @hiit.save
      flash[:success] = "作成しました!"
      redirect_to hiit_path(current_user)
    else
      render 'hiits/new'
    end
  end

  def new
    @hiit = current_user.hiits.new
  end

  def edit
    @hiit = current_user.hiits.find(params[:id])
  end

  def update
    @hiit = current_user.hiits.find(params[:id])
    if @hiit.update(hiit_params)
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

  private
  # ストロングパラメーター
  def hiit_params
    params.require(:hiit).permit(:training_day, :training_time, :content)
  end

  # 現在のユーザーが削除対象のhiitを保有しているかどうかを確認します。
  def correct_user
    @hiit = current_user.hiits.find_by(id: params[:id])
    redirect_to root_url if @hiit.nil?
  end
end