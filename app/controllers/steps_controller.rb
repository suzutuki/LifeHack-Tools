class StepsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy
  before_action :correct_user_destroy_all, only: :destroy_all

  #chart.jsの設定
  def index
    @user = current_user
    @step = @user.steps
    @steps = Step.all.order('created_at ASC')
    @times = @steps.map(&:id)
    @dates = @steps.map { |user| user.created_at.strftime('%Y/%m/%d') }
  end

  # @user = User.all
  # # @steps = current_user.steps.build(step_params)
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

  def simple
    # start_day = Date.today-183
    # end_day = Date.today
    # gon.monthly = (start_day..end_day).select {|day| day.day == 1}
    # gon.monthly.each_with_index do |month, i|
    #   newmonth = month.strftime("%Y年%m月")
    #   gon.monthly[i] = newmonth
    # end
    # sum = 0
    # array = Step.where(user_id: current_user.id).where(day: start_day..end_day).group("DATE_FORMAT(date, '%Y年%m月')").count
    # gon.data = array.values # この段階でイベントへ行っていない月は0で配列に加えておきたい
    # gon.linedata = []
    # gon.data.each do |data|
    #   sum += data
    #   gon.linedata << sum
    # end
  end

  def show
    @user = User.find(params[:id])
    @step = @user.steps
  end

  def new
    @steps = StepCollection.new(current_user)
  end

  def create
    @steps = StepCollection.new(current_user, steps_params)
    if @steps.save
      flash[:success] = '成功しました!'
      redirect_to step_path(current_user)
    else
      render 'new'
    end
  end



  def example
  end

  def goal
    @step = Step.new
  end

  def goal_create
    @step = current_user.steps.build(step_params)
    if @step.save
      flash[:success] = "｢#{@step.goal}｣を作成しました！"
      redirect_to step_path(current_user)
    end
  end



  def edit
  end

  def update
    if current_user.update(user_steps_params)
      flash[:success] = "編集しました!"
      redirect_to step_path(current_user)
    else
      render 'steps/edit'
    end
  end

  def destroy
    @step = Step.find(params[:id])
    @step.destroy
    redirect_to request.referrer || root_url
  end

  # 一括削除
  def destroy_all
    @steps.destroy_all
    flash[:danger] = "全て削除しました!"
    redirect_to request.referrer || root_url
  end

  def toggle
    head :no_content
    step = Step.find(params[:id])
    step.done = !step.done
    step.save
  end

  private

  # ストロングパラメーターcreate用
  def steps_params
    params.require(:steps)
  end

  #ストロングパラメーター
  def step_params
    params.require(:step).permit(:day, :done, :id, :goal, :name,)
  end

  # ストロングパラメーターupdate用
  def user_steps_params
    params.require(:user).permit(steps_attributes: [:day, :done, :id, :goal, :name, :event_id])
  end

  def correct_user
    @steps = current_user.steps.find_by(id: params[:id])
    redirect_to root_url if @steps.nil?
  end

  # 現在のユーザーが削除対象のitsを保有しているかどうかを確認します。
  def correct_user_destroy_all
    @steps = current_user.steps
    redirect_to root_url if @steps.nil?
  end
end