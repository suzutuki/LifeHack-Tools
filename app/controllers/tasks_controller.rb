class TasksController < ApplicationController
  before_action :logged_in_user, only: [:create, :edit, :destroy]
  before_action :correct_user, only: :destroy
  before_action :correct_user_destroy_all, only: :destroy_all
  skip_before_action :verify_authenticity_token

  def index
    @tasks = ask.all
  end

  def show
    @tasks = current_user.tasks
  end

  def new
    @tasks = TaskCollection.new(current_user)
  end

  def create
    @tasks = TaskCollection.new(current_user, tasks_params)
    if @tasks.save
      flash[:success] = "作成しました!"
      redirect_to task_path(current_user)
    else
      render "new"
    end
  end

  def edit
  end

  def update
    if current_user.update(user_tasks_params)
      flash[:success] = "編集しました!"
      redirect_to task_path(current_user)
    else
      render "tasks/edit"
    end
  end

  def destroy
    @task.destroy
    flash[:danger] = "｢#{@task.title}｣を削除しました!"
    redirect_to request.referrer || root_url
  end

  # 一括削除
  def destroy_all
    @tasks.destroy_all
    flash[:danger] = "全て削除しました!"
    redirect_to request.referrer || root_url
  end

  def toggle
    head :no_content
    task = Task.find(params[:id])
    task.done = !task.done
    task.save
  end

  private

  # ストロングパラメーターcreate用
  def tasks_params
    params.require(:tasks)
  end

  #ストロングパラメーター
  def task_params
    params.require(:step).permit(:title, :content, :priority, :id)
  end

  # ストロングパラメーターupdate用
  def user_tasks_params
    params.require(:user).permit(tasks_attributes: [:title, :content, :id, :priority, :admin])
  end

  # 現在のユーザーが削除対象のtaskを保有しているかどうかを確認します。
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    redirect_to root_url if @task.nil?
  end

  # 現在のユーザーが削除対象のtasksを保有しているかどうかを確認します。
  def correct_user_destroy_all
    @tasks = current_user.tasks
    redirect_to root_url if @tasks.nil?
  end
end
