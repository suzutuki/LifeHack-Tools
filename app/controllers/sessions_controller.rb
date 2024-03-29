class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      log_in @user
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_to root_url
    else
      flash.now[:danger] = 'メールアドレスとパスワードの組み合わせがおかしいようです。'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    flash[:danger] = "ログアウトしました！"
    redirect_to root_url
  end
end
