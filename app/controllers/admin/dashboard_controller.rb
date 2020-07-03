
#Admin dashboard

class Admin::DashboardController < ApplicationController
  before_action :require_admin

  def index
  end

  def require_admin
    unless current_user && current_user.admin?
      store_location_for(:user, request.url)
      redirect_to new_user_session_path, alert: 'You must be logged in as a admin to access this section'
    end   
  end
end
