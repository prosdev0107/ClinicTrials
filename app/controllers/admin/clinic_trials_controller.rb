class Admin::ClinicTrialsController < ApplicationController
  @@baseURI = "https://clinicaltrials.gov/api/query/study_fields"
  @@countURI = "https://clinicaltrials.gov/api/query/field_values"
  def import
    @page = 0
    @count = JSON.parse(HTTParty.get(@@countURI + count_params))["FieldValuesResponse"]["NStudiesFound"].to_i
    @rawRecords = Array.new
    loop do
      @min_rank = @page * 100 + 1
      @max_rank = (@page + 1) * 100
      @query = "?fmt=JSON&expr=Psoriatic+Arthritis&fields=NCTId,BriefTitle,OverallStatus&min_rnk=#{@min_rank}&max_rnk=#{@max_rank}"
      @ctlist = JSON.parse(HTTParty.get(@@baseURI + @query))["StudyFieldsResponse"]["StudyFields"]
      @ctlist.map { |trial|
        if ClinicTrial.where(upidnumber: trial['NCTId'][0]).count <= 0
          @rawRecords.push trial
        end
      }
      break if @max_rank >= @count
      @page += 1
    end
    @trials = Kaminari.paginate_array(@rawRecords).page(params[:page]).per(5)
  end

  def index
    @trials = ClinicTrial.order(:id).page params[:page]
  end
  
  def create
    @page = 0
    @count = JSON.parse(HTTParty.get(@@countURI + count_params))["FieldValuesResponse"]["NStudiesFound"].to_i
    loop do
      @min_rank = @page * 100 + 1
      @max_rank = (@page + 1) * 100
      @query = "?fmt=JSON&expr=Psoriatic+Arthritis&fields=NCTId,BriefTitle,OverallStatus&min_rnk=#{@min_rank}&max_rnk=#{@max_rank}"
      @ctlist = JSON.parse(HTTParty.get(@@baseURI + @query))["StudyFieldsResponse"]["StudyFields"]
      @ctlist.map { |trial|
        ClinicTrial.find_or_create_by(upidnumber: trial['NCTId'][0]) do |c|
          c.trial_name = trial['BriefTitle'][0]
          c.trial_status = trial['OverallStatus'][0]
          c.bf_status = true
        end
      }
      break if @max_rank >= @count
      @page += 1
    end
    redirect_to admin_clinic_trials_import_path
  end

  def update
    bf_status_ids = params[:bf_status].collect {|id| id.to_i} if params[:bf_status]
    seen_ids = params[:seen].collect {|id| id.to_i} if params[:seen]
    if bf_status_ids
      seen_ids.each do |id|
        r = ClinicTrial.find_by_id(id)
        r.bf_status = bf_status_ids.include?(id)
        r.save
      end
    end
    redirect_to admin_clinic_trials_path
  end

  def show
    unless params[:id].present? 
      redirect_to "index"
    end
    @query="https://clinicaltrials.gov/api/query/full_studies?expr=Psoriatic+Arthritis+AREA[NCTId]#{params[:id]}&min_rnk=1&max_rnk=&fmt=json"
    @request = HTTParty.get(@query)
    if @request.code == 200
      @ctlist = JSON.parse(@request)["FullStudiesResponse"]["FullStudies"][0]
    end
  end

  # def search_params
  #   @min_rank = 1
  #   @max_rank = 5
  #   if params[:page].present?
  #     @page = params[:page].to_i
  #     @min_rank = (@page - 1) * 5 + 1
  #     @max_rank = @page * 5
  #   end
  #   @query = "?fmt=JSON&expr=Psoriatic+Arthritis&fields=NCTId,BriefTitle,OverallStatus&min_rnk=#{@min_rank}&max_rnk=#{@max_rank}"
  # end
  
  def count_params
    @query = "?fmt=JSON&expr=Psoriatic+Arthritis&field=Condition"
  end

end
