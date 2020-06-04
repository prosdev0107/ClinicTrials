class ClinicalTrialApi
  include HTTParty
  base_uri 'https://clinicaltrials.gov/api/query'

  def initialize
  end

  def get_count
    options = { 
      query: { 
        fmt: "JSON",
        expr: "Psoriatic Arthritis",
        field: "Condition"
      }
    }
    count ||= JSON.parse(self.class.get('/field_values', options))['FieldValuesResponse']['NStudiesFound'].to_i
  end

  def fetch_detail(id)
    options = { 
      query: { 
        fmt: "JSON",
        expr: "Psoriatic Arthritis AREA[NCTId]#{id}",
        fields: "NCTId,BriefTitle,OverallStatus",
      }
    }
    request = self.class.get("/full_studies", options)
    if request.code == 200
      result = JSON.pretty_generate(JSON.parse(request)["FullStudiesResponse"]["FullStudies"][0])
    end
  end

  def fetch(page, per)
    min = (page - 1) * per + 1
    max = page * per

    options = { 
      query: { 
        fmt: "JSON",
        expr: "Psoriatic Arthritis",
        fields: "NCTId,BriefTitle,OverallStatus",
        min_rnk: min,
        max_rnk: max,
      }
    }
    results = JSON.parse(self.class.get("/study_fields", options))["StudyFieldsResponse"]["StudyFields"]
  end
end