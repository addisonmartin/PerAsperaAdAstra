class SatellitesController < ApplicationController
  before_action :set_satellite, only: %i[ show edit update destroy ]

  # GET /satellites or /satellites.json
  def index
    @satellites = Satellite.includes(:orbit).all
  end

  # GET /satellites/1 or /satellites/1.json
  def show
  end

  # GET /satellites/new
  def new
    @satellite = Satellite.new
  end

  # GET /satellites/1/edit
  def edit
  end

  # POST /satellites or /satellites.json
  def create
    @satellite = Satellite.new(satellite_params)

    respond_to do |format|
      if @satellite.save
        format.html { redirect_to @satellite, notice: "Satellite was successfully created." }
        format.json { render :show, status: :created, location: @satellite }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @satellite.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /satellites/1 or /satellites/1.json
  def update
    respond_to do |format|
      if @satellite.update(satellite_params)
        format.html { redirect_to @satellite, notice: "Satellite was successfully updated." }
        format.json { render :show, status: :ok, location: @satellite }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @satellite.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /satellites/1 or /satellites/1.json
  def destroy
    @satellite.destroy
    respond_to do |format|
      format.html { redirect_to satellites_url, notice: "Satellite was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_satellite
    @satellite = Satellite.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def satellite_params
    params.require(:satellite).permit(:name, :catalog_id, :international_designation, :launch_date, :decay_date, :country, :launch_site, :space_object_type, :radar_cross_section_size, :element_number, :tles)
  end
end
