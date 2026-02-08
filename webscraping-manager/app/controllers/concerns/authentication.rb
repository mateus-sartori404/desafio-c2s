module Authentication
  extend ActiveSupport::Concern

  included do
    helper_method :current_user, :signed_in?
    before_action :load_current_user
  end

  def sign_in!(token:, user:)
    cookies.encrypted[:auth_token] = {
      value: token,
      httponly: true,
      secure: Rails.env.production?,
      same_site: :lax
    }

    session[:current_user] = user
    @current_user = user
  end

  def sign_out!
    cookies.delete(:auth_token)
    session.delete(:current_user)
    @current_user = nil
  end

  def signed_in?
    @current_user.present?
  end

  def require_authentication!
    return if signed_in?

    redirect_to login_path, alert: "Please sign in to continue."
  end

  private

  def load_current_user
    @current_user = session[:current_user]
  end
end
