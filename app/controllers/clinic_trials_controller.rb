#Clinical trils controller for Patients.


class ClinicTrialsController < ApplicationController
  before_action :require_login, only: [:interest]
  def index
    @trials = ClinicTrial.where(bf_status: true).order(:id).page params[:page]
  end

  def show
    unless params[:id].present? 
      redirect_to "index"
    end

    @trial_detail = ClinicalTrialApi.new.fetch_detail(params[:id])
    trial = ClinicTrial.where(upidnumber: params[:id]).first
    @is_applied = TrialUserRelation.where({ clinic_trial_id: trial.id, user_id: current_user.id }).count
  end

  def interest
    unless params[:id].present? 
      redirect_to "index"
    end

    trial = ClinicTrial.where(upidnumber: params[:id]).first
    relation = TrialUserRelation.new
    if current_user && trial.id
      relation.user_id = current_user.id
      relation.clinic_trial_id = trial.id
    end
    if relation.save
      flash[:notice] = "Your interest has be submitted successfully!"
      redirect_to clinic_trials_path
    else 
      flash[:error] = "There is an error during saving data."
      render :show
    end
  end

  def require_login
    unless user_signed_in?
      store_location_for(:user, request.url)
      flash[:error] = "You must be logged in as a patient to access this section"
      redirect_to new_user_session_path
    end
  end
end
