module ApplicationHelper
  def current_user
    session[:email] = "ci@example.com" if Rails.configuration.x.bypass_auth == true
    @current_user ||= session[:email]
  end

  def user_signed_in?
    !!current_user
  end

  def ci?
    Rails.configuration.x.bypass_auth == true
  end
end
