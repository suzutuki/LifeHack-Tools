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
  
  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to root_url
    else
    render 'edit'
    end
  end
  
  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to root_url
  end
  
  def toggle
    head :no_content
    @task = Task.find(params[:id])
    @task.done = !task.done
    @task.save
  end
  private
    def task_params
      params[:task].permit(:title)
    end
end
