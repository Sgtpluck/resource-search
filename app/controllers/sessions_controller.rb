class SessionsController < ApplicationController
  # skip_before_action :require_user!

  def create
    session[:email] = auth_info.email

    redirect_to root_path
  end

  def destroy
    reset_session

    redirect_to root_path
  end

  private

  def auth_info
    @auth_info || Session.new(params[:code])
  end
end
