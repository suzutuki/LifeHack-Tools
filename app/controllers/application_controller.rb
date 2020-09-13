class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  # ログイン済みユーザーかどうか確認する
  def logged_in_user
    unless logged_in?
      store_location
    end
  end


end
