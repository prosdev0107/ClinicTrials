require 'json'

#Import and create Clinical trials from clinictrials.gov
class Admin::ClinicTrialsController < ApplicationController
  before_action :require_admin

  def import
    @trials = ClinicTrial.where(is_new: true).order(:id).page params[:page]
  end

  def create
    service = ClinicalTrialApi.new
    page = 1
    per = 100
    total = service.get_count
    while page < total / per
      page_results = service.fetch(page, per)

      break if page_results.size == 0
      page_results.map { |trial|
        ClinicTrial.find_or_create_by!(upidnumber: trial['NCTId'][0]) do |c|
          c.trial_name = trial['BriefTitle'][0]
          c.trial_status = trial['OverallStatus'][0]
          c.bf_status = false
          c.is_new = true
        end
      }
      page = page + 1
    end
    redirect_to admin_path(:new)
  end

  def index
    @trials = ClinicTrial.where(search_param).order(:id).page params[:page]
  end

  def update
    if params[:bf_status] && params[:seen]
      bf_status_ids = (params[:bf_status] || []).map(&:to_i)
      seen_ids = (params[:seen] || []).map(&:to_i)
      seen_ids.each do |id|
        r = ClinicTrial.update(id, :bf_status => bf_status_ids.include?(id))
      end
    else
      ClinicTrial.update_all(is_new: false)
    end
    redirect_to admin_clinic_trials_path
  end

  def show
    unless params[:id].present? 
      redirect_to "index"
    end

    @ctlist = ClinicalTrialApi.new.fetch_detail(params[:id])
    trial = ClinicTrial.where(upidnumber: params[:id]).first
    @relations = TrialUserRelation.joins(:user).where(clinic_trial_id: trial.id)
  end

  def patients
    unless params[:id].present? 
      redirect_to "index"
    end

  end

  def require_admin
    unless current_user && current_user.admin?
      store_location_for(:user, request.url)
      redirect_to new_user_session_path, alert: 'You must be logged in as a admin to access this section'
    end   
  end

  def search_param
    params.permit(:is_new, :bf_status)
  end
end
