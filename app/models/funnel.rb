class Funnel

  def self.applicants_by_stage(start_date, end_date)
    funnel_stage_counts = Applicant.created_range(start_date, end_date)
                                   .by_created_at_week
                                   .by_workflow_state
                                   .count(:workflow_state)

    mapped_counts = funnel_stage_counts.inject(Hash.new{ |h, key| h[key] = {} }) do |hash,(keys, value)|
      parsed_date = Date.parse(keys.first)
      date_range_key = "#{parsed_date.beginning_of_week}-#{parsed_date.end_of_week}"
      hash[date_range_key][keys.last] = value
      hash
    end
  end

end
