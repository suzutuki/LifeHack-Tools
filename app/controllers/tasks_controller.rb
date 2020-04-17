class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end
  def new
    @task = Task.new
  end
  def edit
    @task = Task.find(params[:id])
  end
  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to root_url
  end
  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to root_url
    else
      render 'new'
    end
  end
  def toggle
    head :no_content
    @task = Task.find(params[:id])
    @task.done = !task.done
    @task.save
  end
  private
    def tasks_params
      params[:task].permit(:title)
    end
end
