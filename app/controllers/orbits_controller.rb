class OrbitsController < ApplicationController
  before_action :set_orbit, only: %i[ show edit update destroy ]

  # GET /orbits or /orbits.json
  def index
    @orbits = Orbit.includes(:satellite).all
  end

  # GET /orbits/1 or /orbits/1.json
  def show
  end

  # GET /orbits/new
  def new
    @orbit = Orbit.new
  end

  # GET /orbits/1/edit
  def edit
  end

  # POST /orbits or /orbits.json
  def create
    @orbit = Orbit.new(orbit_params)

    respond_to do |format|
      if @orbit.save
        format.html { redirect_to @orbit, notice: "Orbit was successfully created." }
        format.json { render :show, status: :created, location: @orbit }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @orbit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orbits/1 or /orbits/1.json
  def update
    respond_to do |format|
      if @orbit.update(orbit_params)
        format.html { redirect_to @orbit, notice: "Orbit was successfully updated." }
        format.json { render :show, status: :ok, location: @orbit }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @orbit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orbits/1 or /orbits/1.json
  def destroy
    @orbit.destroy
    respond_to do |format|
      format.html { redirect_to orbits_url, notice: "Orbit was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_orbit
    @orbit = Orbit.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def orbit_params
    params.require(:orbit).permit(:name, :epoch, :first_derivative_of_mean_motion, :second_derivative_of_mean_motion, :b_star, :inclination, :apogee, :perigee, :period, :right_ascension_of_ascending_node, :eccentricity, :argument_of_perigee, :mean_anomaly, :mean_motion, :revolution_number, :tles, :satellite_id)
  end
end
