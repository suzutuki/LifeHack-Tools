class ListsController < ApplicationController
  # before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def index
  end

  def sample
    @user = User.find(params[:id])
    @lists = @user.lists
  end

  def swipe
  end

  def new
    @list = List.new
  end

  def edit
    @list = List.find(params[:id])
  end

  def create
    @list = current_user.lists.build(list_params)
    if @list.save
      flash[:success] = "成功しました!"
      redirect_to list_path(current_user)
    else
      render 'lists/new'
    end
  end

  def show
    @user = User.find(params[:id])
    @lists = @user.lists
  end

  def update
    @list = List.find(params[:id])
    if @list.update(list_params)
      flash[:success] = "編集しました!"
      redirect_to list_path(current_user)
    else
      render 'lists/edit'
    end
  end

  def destroy
    @list.destroy
    flash[:danger] = "削除しました!"
    redirect_to request.referrer || root_url
  end

  private

  def list_params
    params.require(:list).permit(:answer, :event, :respect,
                                 :disdain, :boss, :guidance, :rate, :question)
  end

  def correct_user
    @list = current_user.lists.find_by(id: params[:id])
    redirect_to root_url if @list.nil?
  end
end
