class TasksController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  skip_before_action :verify_authenticity_token
  
  def index
    # @tasks = Task.all
    # @tasks = Task.page(params[:page]).per(10)
    @task = current_user.tasks.build if logged_in?
  end
  
  def new
    @task = Task.new
  end
  
  def edit
    @task = Task.find(params[:id])
    if @task.save
    flash[:success] = "リストを編集しました！"
    end
  end
  
  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = "リストを作成しました！"
      redirect_to user_path(current_user)
    else
      render 'tasks/new'
    end
  end
  # def create
  #   @task = Task.new(task_params)
  #   if @task.save
  #     redirect_to root_url
  #   else
  #     render 'new'
  #   end
  # end
  
  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to user_path(current_user)
    else
    render 'edit'
    end
  end
  
  def destroy
    @task.destroy
    flash[:success] = "削除しました"
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
      params.require(:task).permit(:title, :content)
    end
    
    def correct_user
      @task = current_user.tasks.find_by(id: params[:id])
      redirect_to root_url if @task.nil?
    end
end
