class Admin::LogosController < Admin::BaseController

  before_action :set_logo, only: [:edit, :update, :destroy]

  def new
    @logo = Logo.new
  end

  def create
    @logo = Logo.new(logo_params)
    if @logo.save
      redirect_to admin_application_images_path, notice: 'Logo successfully created.'
    else
      flash[:alert] = 'Please select an image.'
      render :new
      flash.clear
    end
  end

  def edit
  end

  def update
    if params[:logo][:image] && @logo.update(logo_params)
      redirect_to admin_application_images_path, notice: 'Logo successfully updated.'
    else
      flash[:alert] = 'Please select an image.'
      render :edit
      flash.clear
    end
  end

  def destroy
    if @logo.destroy
      redirect_to admin_application_images_path, notice: 'Logo successfully removed.'
    else
      redirect_to admin_application_images_path, alert: 'Could not remove logo.'
    end
  end

  protected

  def set_logo
    unless @logo = Logo.find_by(id: params[:id])
      redirect_to admin_application_images_path, alert: 'No logo found.'
    end
  end

  def logo_params
    params.require(:logo).permit(:image)
  end
  
end