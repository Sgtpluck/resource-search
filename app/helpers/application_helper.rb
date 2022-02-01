module ApplicationHelper
  def current_user
    session[:email] = "ci@example.com" if bypass_auth?
    @current_user ||= session[:email]
  end

  def user_signed_in?
    !!current_user
  end

  def bypass_auth?
    Rails.configuration.x.bypass_auth == true
  end
end
