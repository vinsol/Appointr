class ServicesController < ApplicationController

  before_action :set_service, only: [:show, :edit, :update, :destroy]
  before_action :check_admin_logged_in, except: :index

  def index
    @services = Service.order(:name)
  end

  def show
  end

  def new
    @service = Service.new
  end

  def edit
  end

  def create
    @service = Service.new(service_params)
    respond_to do |format|
      if @service.save
        format.html { redirect_to @service,
          notice: 'Service was successfully created.' }
        format.json { render action: 'show', status: :created,
          location: @service }
      else
        format.html { render action: 'new' }
        format.json { render json: @service.errors,
          status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @service.update(service_params)
        format.html { redirect_to @service,
          notice: 'Service was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @service.errors,
          status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service
      @service = Service.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white
    # list through.
    def service_params
      params.require(:service).permit(:name, :duration, :enabled?)
    end

    def check_admin_logged_in
      if !current_admin
        redirect_to new_admin_session_path
      end
    end
end
