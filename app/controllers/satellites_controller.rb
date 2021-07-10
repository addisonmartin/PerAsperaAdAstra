class SatellitesController < ApplicationController
  before_action :set_satellite, only: %i[ show edit update destroy ]

  # GET /satellites or /satellites.json
  def index
    @satellites = search.page(params[:page])
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

  # Constructs a query based on the parameters the user selected in the search form, then executes that query.
  def search
    search_query = ''
    search_options = []

    unless params[:name].blank?
      search_query += 'name ILIKE ?'
      search_options << "%#{params[:name]}%"
    end
    unless params[:catalog_id].blank?
      search_query += 'AND catalog_id = ?'
      search_options << params[:catalog_id]
    end
    unless params[:international_designation].blank?
      search_query += 'AND international_designation ILIKE ?'
      search_options << "%#{params[:international_designation]}%"
    end
    unless params[:launch_date].blank?
      search_query += 'AND launch_date = ?'
      search_options << params[:launch_date]
    end
    unless params[:decay_date].blank?
      search_query += 'AND decay_date = ?'
      search_options << params[:decay_date]
    end
    unless params[:country].blank?
      search_query += 'AND country = ?'
      search_options << params[:country]
    end
    unless params[:launch_site].blank?
      search_query += 'AND launch_site = ?'
      search_options << params[:launch_site]
    end
    unless params[:space_object_type].blank?
      search_query += 'AND space_object_type = ?'
      search_options << params[:space_object_type]
    end
    unless params[:radar_cross_section_size].blank?
      search_query += 'AND radar_cross_section_size = ?'
      search_options << params[:radar_cross_section_size]
    end

    if search_query.empty?
      Satellite.includes(:orbit).all
    else
      search_query = search_query.delete_prefix('AND ')
      Satellite.includes(:orbit).where(search_query, *search_options)
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_satellite
    @satellite = Satellite.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def satellite_params
    params.require(:satellite).permit(:name, :catalog_id, :international_designation, :launch_date, :decay_date, :country, :launch_site, :space_object_type, :radar_cross_section_size, :element_number, :tles)
  end
end
