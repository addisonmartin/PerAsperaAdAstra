class SatellitesController < ApplicationController

  # GET /satellites
  def index
    # Sort and filter the satellites.
    @q = Satellite.ransack(params[:q])
    # Paginate the result of the filter and sort.
    @pagy, @satellites = pagy(@q.result)
  end

  # GET /satellites/1
  def show
    @satellite = Satellite.find(params[:id])
  end

  private

  # Only allow a trusted parameter "white list" through:
  def satellite_params
    params.require(:satellite).permit(:norad_catalog_id,
                                      :international_designator,
                                      :name,
                                      :object_name,
                                      :object_type,
                                      :object_id,
                                      :object_number,
                                      :country,
                                      :launch_date,
                                      :launch_site,
                                      :decay_date,
                                      :launch_year,
                                      :launch_number,
                                      :launch_piece,
                                      :period,
                                      :inclination,
                                      :apogee,
                                      :perigee,
                                      :radar_cross_section_value,
                                      :radar_cross_section_size,
                                      :comment,
                                      :comment_code,
                                      :file,
                                      :current)
  end
end
