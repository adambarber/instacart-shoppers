class FunnelsController < ApplicationController

  def index
    start_date = params.fetch(:start_date, 1.week.ago)
    end_date = params.fetch(:end_date, Time.zone.now)
    @funnels = Funnel.applicants_by_stage(start_date, end_date)
    render json: @funnels.to_json
  end
end
