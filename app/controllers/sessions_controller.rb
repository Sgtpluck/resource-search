class SessionsController < ApplicationController
  # skip_before_action :require_user!

  def create
    begin
      session[:email] = auth_info.email
    rescue JWT::VerificationError
      session[:email]&.delete
    end
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
