class SportsController < ApplicationController

  def index

  end
  
  def create
    @sport = current_user.sports.build(sport_params)
    if @sport.save
      flash[:success] = "作成しました!"
      redirect_to sport_path(current_user)
    else
      render 'sports/new'
    end
  end

  def update
    if current_user.sports.update(sport_params)
      flash[:success] = "編集しました!"
      redirect_to sport_path(current_user)
    else
      render 'sports/edit'
    end
  end

  def destroy
    @sport.destroy
    redirect_to request.referrer || root_url
  end

  
  def new
    @sport = current_user.sports.new
  end
  
  def edit
    @sport = current_user.sports.find(params[:id])
  end

  def show
    @user = current_user
    @graphdays =  @user.sports.order(sport_day: "DESC").limit(6).reverse
    @dayline = Array.new
    @graphdays.each do |graphday|
      @dayline.push(graphday.sport_day.strftime('%m/%d').to_s)
    end
    @graphtimes =  @user.sports.order(sport_day: "DESC").limit(6).reverse
    @timeline = Array.new
    @graphtimes.each do |graphtime|
      @timeline.push(graphtime.sport_time)
    end
  end
  # @user = current_user
  # @steps = current_user.steps.build(step_params)
  # @graphdays =  @user.steps.order(created_at: "DESC").limit(6).reverse
  # @dayline = Array.new
  # @graphdays.each do |graphday|
  #   @dayline.push(graphday.created_at.strftime('%m/%d').to_s)
  # end
  # @graphtimes =  @user.steps.order(created_at: "DESC").limit(6).reverse
  # @timeline = Array.new
  # @graphtimes.each do |graphtime|
  #   @timeline.push(graphtime.created_at)
  # end

  private
  # ストロングパラメーター
  def sport_params
    params.require(:sport).permit(:sport_day, :sport_time)
  end

  # 現在のユーザーが削除対象のsportを保有しているかどうかを確認します。
  def correct_user
    @sport = current_user.sports.find_by(id: params[:id])
    redirect_to root_url if @sport.nil?
  end
end
