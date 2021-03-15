class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger
  protect_from_forgery with: :null_session
  include SessionsHelper

  private
  # ログイン済みユーザーかどうか確認する
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください"
      redirect_to login_url
    end
  end
end
