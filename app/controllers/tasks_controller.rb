class TasksController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy
  skip_before_action :verify_authenticity_token
  before_action :set_target_user, only: [:edit, :update]

  def index
  # @tasks = Task.all
  # @tasks = Task.page(params[:page]).per(10)
  # @task = current_user.tasks.build if logged_in?
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def show
    @user = User.find(params[:id])
    @tasks = @user.tasks.page(params[:page]).per(8)
  end
  # ユーザーidに紐付いたタスクを作成
  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = "｢#{@task.title}｣を作成しました！"
      redirect_to task_path(current_user)
    else
      render 'tasks/new'
    end
  end

  def update
    if @task.update(task_params)
      flash[:success] = "｢#{@task.title}｣に変更しました！"
      redirect_to user_path(current_user)
    else
      render 'edit'
    end
  end

  def destroy
    @task.destroy
    flash[:danger] = "｢#{@task.title}｣を削除しました!"
    redirect_to request.referrer || root_url
  end

  def toggle
    head :no_content
    task = Task.find(params[:id])
    task.done = !task.done
    task.save
  end

  private

  #ストロングパラメーター
  def task_params
    params.require(:task).permit(:title, :content, :priority)
  end

  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    redirect_to root_url if @task.nil?
  end

  #リファクタリング用
  def set_target_user
    @task = Task.find(params[:id])
  end
end
