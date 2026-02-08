class DashboardController < ApplicationController
  def show
    render inertia: "Dashboard", props: { user: current_user }
  end
end
