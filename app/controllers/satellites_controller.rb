class SatellitesController < ApplicationController
  before_action :set_satellite, only: [:show, :edit, :update, :destroy]

  # GET /satellites
  def index
    # Paginate the models for display.
    @pagy, @satellites = pagy(Satellite.all)
  end

  # GET /satellites/1
  def show
  end

  # GET /satellites/new
  def new
    @satellite = Satellite.new
  end

  # GET /satellites/1/edit
  def edit
  end

  # POST /satellites
  def create
    @satellite = Satellite.new(satellite_params)

    if @satellite.save
      redirect_to @satellite, notice: 'Satellite was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /satellites/1
  def update
    if @satellite.update(satellite_params)
      redirect_to @satellite, notice: 'Satellite was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /satellites/1
  def destroy
    @satellite.destroy
    redirect_to satellites_url, notice: 'Satellite was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_satellite
    @satellite = Satellite.find(params[:id])
  end

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
