class SessionsController < ApplicationController
  def new
    render inertia: "Auth/Login"
  end

  def create
    payload = AuthServiceClient.new.login(
      email: params.require(:email),
      password: params.require(:password)
    )

    sign_in!(token: payload["token"], user: payload["user"])
    redirect_to dashboard_path, notice: "Successfully signed in!"
  rescue AuthServiceClient::AuthenticationError => e
    flash.now[:alert] = e.message
    render inertia: "Auth/Login", status: :unprocessable_entity
  rescue AuthServiceClient::Error => e
    flash.now[:alert] = "An error occurred while trying to sign in. Please try again later."
    render inertia: "Auth/Login", status: :internal_server_error
  end

  def destroy
    sign_out!
    redirect_to login_path, notice: "Successfully signed out!"
  end
end
