class RegistrationsController < ApplicationController
  def new
    render inertia: "Auth/Register"
  end

  def create
    Rails.logger.info "Attempting registration for email: #{login_params[:email]}"

    AuthServiceClient.new.register(login_params[:email], login_params[:password], login_params[:password_confirmation])

    payload = AuthServiceClient.new.login(
      email: params.require(:email),
      password: params.require(:password)
    )

    sign_in!(token: payload["token"], user: payload["user"])
    redirect_to dashboard_path, notice: "Successfully registered and signed in!"
  rescue AuthServiceClient::UnprocessableEntity => e
    flash.now[:alert] = e.message
    render inertia: "Auth/Register", status: :unprocessable_entity
  rescue AuthServiceClient::Error => e
    flash.now[:alert] = "An error occurred while trying to register. Please try again later."
    render inertia: "Auth/Register", status: :internal_server_error
  end

  def login_params
    params.fetch(:registration, {}).permit(:email, :password, :password_confirmation)
  end
end
